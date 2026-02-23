class AniListCharacter {
  final int id;
  final String name;
  final String imageUrl;

  AniListCharacter({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory AniListCharacter.fromJson(Map<String, dynamic> json) {
    final nameData = json['name'] ?? {};
    final imageData = json['image'] ?? {};
    return AniListCharacter(
      id: json['id'] ?? 0,
      name: nameData['full'] ?? nameData['first'] ?? 'Desconocido',
      imageUrl: imageData['medium'] ?? '',
    );
  }
}
