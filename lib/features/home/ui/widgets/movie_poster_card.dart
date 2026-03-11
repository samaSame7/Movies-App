import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../movie_details/ui/screens/movie_details_screen.dart';
import '../../models/movie_model.dart';

class MoviePosterCard extends StatelessWidget {
  final MovieModel movie;
  final double width;
  final double height;

  const MoviePosterCard({
    super.key,
    required this.movie,
    this.width = 140,
    this.height = 210,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movieId: movie.id),
          ),
        );
      },
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.fieldFill,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                movie.mediumCoverImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.broken_image, color: AppColors.textHint),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                },
              ),

              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:AppColors.background.withAlpha(150),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        movie.rating.toString(),
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star,
                        color: AppColors.primary,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
