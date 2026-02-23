import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/anilist_character.dart';
export '../models/anilist_character.dart';

class AniListService {
  static const String _url = 'https://graphql.anilist.co';

  // Pool de personajes cargado una sola vez
  static List<AniListCharacter>? _pool;

  static String _buildQuery(int page) => '''
    query {
      Page(page: $page, perPage: 50) {
        characters(sort: FAVOURITES_DESC) {
          id
          name {
            first
            middle
            last
            full
            native
            userPreferred
          }
          image {
            large
            medium
          }
        }
      }
    }
  ''';

  /// Obtiene personajes de una página concreta.
  static Future<List<AniListCharacter>> _fetchPage(int page) async {
    final response = await http.post(
      Uri.parse(_url),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'query': _buildQuery(page)}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final characters = data['data']?['Page']?['characters'] as List?;
      if (characters != null && characters.isNotEmpty) {
        return characters.map((c) => AniListCharacter.fromJson(c)).toList();
      }
    }
    return [];
  }

  /// Carga los 200 personajes más populares (4 páginas de 50).
  /// Solo hace las peticiones la primera vez; luego reutiliza el pool.
  static Future<List<AniListCharacter>> fetchPopularCharacters() async {
    if (_pool != null && _pool!.isNotEmpty) return _pool!;

    final results = await Future.wait([
      _fetchPage(1),
      _fetchPage(2),
      _fetchPage(3),
      _fetchPage(4)
    ]);
    _pool = results.expand((list) => list).toList();
    return _pool!;
  }

  /// Genera una pregunta de trivia: 1 personaje correcto + 3 incorrectos.
  /// Usa el pool cargado en memoria, sin hacer peticiones adicionales.
  static Future<Map<String, dynamic>?> fetchTriviaQuestion() async {
    final characters = await fetchPopularCharacters();
    if (characters.length < 4) return null;

    final shuffled = List<AniListCharacter>.from(characters)..shuffle();
    final correct = shuffled[0];
    final wrongOptions = shuffled.sublist(1, 4);
    final options = [correct, ...wrongOptions]..shuffle();

    return {
      'correct': correct,
      'options': options,
    };
  }
}
