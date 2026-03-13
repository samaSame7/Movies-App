import 'package:movies_app/core/app_assets/app_assets.dart';

class OnboardingModel{
  final String image;
  final String title;
  final String? description;

  OnboardingModel({required this.image, required this.title,  this.description});

}
List<OnboardingModel> onboardingList = [
  OnboardingModel(
    image: AppAssets.onBoarding1,
    title: "Find Your Next Favorite Movie Here",
    description: "Get access to a huge library of movies to suit all tastes. You will surely like it.",
  ),
  OnboardingModel(
    image: AppAssets.onBoarding2,
    title: "Discover Movies",
    description: "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
  ),
  OnboardingModel(
    image: AppAssets.onBoarding3,
    title: "Explore All Genres",
    description: "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
  ),
  OnboardingModel(
    image: AppAssets.onBoarding4,
    title: "Create Watch lists",
    description: "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
  ),OnboardingModel(
    image: AppAssets.onBoarding5,
    title: "Rate, Review, and Learn",
    description: "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
  ),OnboardingModel(
    image: AppAssets.onBoarding6,
    title: "Start Watching Now",
  ),
];