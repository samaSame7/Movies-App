class MovieModel {
  final int id;
  final String title;
  final double rating;
  final String mediumCoverImage;
  final List<String> genres;

  MovieModel({
    required this.id,
    required this.title,
    required this.rating,
    required this.mediumCoverImage,
    required this.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      rating: (json['rating'] ?? 0).toDouble(),
      mediumCoverImage: json['medium_cover_image'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
    );
  }
}
