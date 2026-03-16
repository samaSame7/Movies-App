class CastModel {
  final String name;
  final String characterName;
  final String imageUrl;

  CastModel({required this.name, required this.characterName, required this.imageUrl});

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      name: json['name'] ?? 'Unknown',
      characterName: json['character_name'] ?? 'Unknown',
      imageUrl: json['url_small_image'] ?? '',
    );
  }
}

class MovieDetailsModel {
  final int id;
  final String title;
  final int year;
  final double rating;
  final int runtime;
  final int likeCount;
  final String description;
  final String largeCoverImage;
  final String backgroundImageUrl;
  final List<String> genres;
  final List<String> screenshots;
  final List<CastModel> cast;

  MovieDetailsModel({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.likeCount,
    required this.description,
    required this.largeCoverImage,
    required this.backgroundImageUrl,
    required this.genres,
    required this.screenshots,
    required this.cast,
  });

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) {
    List<String> extractedScreenshots = [];
    if (json['medium_screenshot_image1'] != null) extractedScreenshots.add(json['medium_screenshot_image1']);
    if (json['medium_screenshot_image2'] != null) extractedScreenshots.add(json['medium_screenshot_image2']);
    if (json['medium_screenshot_image3'] != null) extractedScreenshots.add(json['medium_screenshot_image3']);

    var castList = json['cast'] as List? ?? [];
    List<CastModel> extractedCast = castList.map((c) => CastModel.fromJson(c)).toList();

    return MovieDetailsModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      year: json['year'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      runtime: json['runtime'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      description: json['description_full'] ?? '',
      largeCoverImage: json['large_cover_image'] ?? '',
      backgroundImageUrl: json['background_image_original'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      screenshots: extractedScreenshots,
      cast: extractedCast,
    );
  }
}