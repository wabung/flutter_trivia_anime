import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/anime_theme_audio.dart';

class AnimeThemesService {
  static const String _anilistUrl = 'https://graphql.anilist.co';

  // Pool de openings cargado una sola vez
  static List<AnimeThemeAudio>? _pool;

  /// Query de AniList para obtener los animes más populares (título romaji).
  static String _buildAnimeQuery(int page) => '''
    query {
      Page(page: $page, perPage: 50) {
        media(sort: POPULARITY_DESC, type: ANIME) {
          id
          title {
            romaji
          }
        }
      }
    }
  ''';

  /// Obtiene los animes más populares de AniList (una página).
  static Future<List<AnimeThemeAudio>> _fetchPopularAnime(int page) async {
    final response = await http.post(
      Uri.parse(_anilistUrl),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'query': _buildAnimeQuery(page)}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final mediaList = data['data']?['Page']?['media'] as List?;
      if (mediaList != null && mediaList.isNotEmpty) {
        return mediaList.map((m) {
          final romaji = m['title']?['romaji'] ?? '';
          final id = m['id'] ?? 0;
          return AnimeThemeAudio.fromRomaji(id: id, romaji: romaji);
        }).toList();
      }
    }
    return [];
  }

  /// Verifica que la URL del audio exista (HEAD request).
  static Future<bool> _audioExists(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// Carga el pool de openings de los animes más populares.
  /// Usa AniList para los títulos y construye las URLs de AnimeThemes.
  static Future<List<AnimeThemeAudio>> fetchAudioPool() async {
    if (_pool != null && _pool!.isNotEmpty) return _pool!;

    // Obtener 100 animes populares (4 requests a AniList, 50 cada una)
    final page1 = await _fetchPopularAnime(1);
    final page2 = await _fetchPopularAnime(2);
    final page3 = await _fetchPopularAnime(3);
    final page4 = await _fetchPopularAnime(4);
    final page5 = await _fetchPopularAnime(5);
    final page6 = await _fetchPopularAnime(6);
    final page7 = await _fetchPopularAnime(7);
    final page8 = await _fetchPopularAnime(8);

    _pool = [...page1, ...page2, ...page3, ...page4, ...page5, ...page6, ...page7, ...page8];

    return _pool!;
  }

  /// Genera una pregunta de trivia: 1 audio correcto + 3 opciones incorrectas.
  static Future<Map<String, dynamic>?> fetchTriviaQuestion() async {
    final audios = await fetchAudioPool();
    if (audios.length < 4) return null;

    final shuffled = List<AnimeThemeAudio>.from(audios)..shuffle();
    final correct = shuffled[0];
    final wrongOptions = shuffled.sublist(1, 4);
    final options = [correct, ...wrongOptions]..shuffle();

    return {
      'correct': correct,
      'options': options,
    };
  }

  /// Limpia el pool para forzar una recarga en la siguiente partida.
  static void resetPool() {
    _pool = null;
  }
}
