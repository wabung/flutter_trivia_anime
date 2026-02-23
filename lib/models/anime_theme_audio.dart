class AnimeThemeAudio {
  final int id;
  final String name;     // Nombre legible: "Shingeki no Kyojin"
  final String audioUrl; // URL del audio .ogg

  AnimeThemeAudio({
    required this.id,
    required this.name,
    required this.audioUrl,
  });

  /// Construye la URL del opening a partir del título romaji de AniList.
  /// Ej: "Shingeki no Kyojin" → "https://a.animethemes.moe/ShingekiNoKyojin-OP1.ogg"
  static String buildAudioUrl(String romajiTitle) {
    final cleaned = romajiTitle
        .replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '') // quitar puntuación
        .split(RegExp(r'\s+'))
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1)
            : '')
        .join('');
    return 'https://a.animethemes.moe/$cleaned-OP1.ogg';
  }

  /// Crea un AnimeThemeAudio desde el título romaji de AniList.
  factory AnimeThemeAudio.fromRomaji({required int id, required String romaji}) {
    return AnimeThemeAudio(
      id: id,
      name: romaji,
      audioUrl: buildAudioUrl(romaji),
    );
  }

  /// Convierte el filename del json a uno legible (para uso directo con la API)
  static String _parseName(String filename) {
    final withoutSuffix = filename.replaceAll(RegExp(r'-(OP|ED)\d+.*$'), '');
    final spaced = withoutSuffix.replaceAllMapped(
      RegExp(r'(?<=[a-z0-9])(?=[A-Z])'),
      (match) => ' ',
    );
    return spaced;
  }

  factory AnimeThemeAudio.fromJson(Map<String, dynamic> json) {
    return AnimeThemeAudio(
      id: json['id'] ?? 0,
      name: _parseName(json['filename'] ?? ''),
      audioUrl: json['link'] ?? '',
    );
  }
}
