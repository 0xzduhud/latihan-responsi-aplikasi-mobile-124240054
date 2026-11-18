class ShowModel {
  final int id;
  final String name;
  final String? image;
  final double? rating;
  final List<String> genres;
  final String summary;

  const ShowModel({
    required this.id,
    required this.name,
    this.image,
    this.rating,
    required this.genres,
    required this.summary,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    final imageData = json['image'];
    final ratingData = json['rating'];
    final rawGenres = json['genres'];

    return ShowModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] ?? 'Untitled').toString(),
      image: imageData is Map ? (imageData['medium'] ?? imageData['original'])?.toString() : null,
      rating: ratingData is Map && ratingData['average'] is num
          ? (ratingData['average'] as num).toDouble()
          : null,
      genres: rawGenres is List ? rawGenres.map((e) => e.toString()).toList() : <String>[],
      summary: _cleanHtml((json['summary'] ?? 'No summary available.').toString()),
    );
  }

  factory ShowModel.fromStored(Map data) {
    return ShowModel(
      id: (data['id'] as num).toInt(),
      name: (data['name'] ?? 'Untitled').toString(),
      image: data['image']?.toString(),
      rating: data['rating'] == null ? null : (data['rating'] as num).toDouble(),
      genres: (data['genres'] as List? ?? []).map((e) => e.toString()).toList(),
      summary: (data['summary'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'image': image,
    'rating': rating,
    'genres': genres,
    'summary': summary,
  };

  static String _cleanHtml(String value) {
    return value
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .trim();
  }
}
