class OnboardingModel {
  final String imagePath;
  final String title;
  final String subtitle;

  OnboardingModel({
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  static List<OnboardingModel> onboardingModels = [
  OnboardingModel(
  imagePath: "imagePath",
  title: "Find Your Next\nFavorite Movie Here",
  subtitle:
  'Get access to a huge library of movies to suit all tastes. You will surely like it.',
  ),
  OnboardingModel(
  imagePath: "imagePath",
  title: 'Discover Movies',
  subtitle:
  'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.',
  ),
  OnboardingModel(
  imagePath: "imagePath",
  title: 'Explore All Genres',
  subtitle:
  'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.',
  ),
  OnboardingModel(
  imagePath: "imagePath",
  title: 'Create Watchlist',
  subtitle:
  'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.',
  ),
  OnboardingModel(
  imagePath: "imagePath",
  title: 'Rate, Review, and Learn',
  subtitle:
  'Share your thoughts on the movies you\'ve watched. Dive deep into film details and help others discover great movies with your reviews.',
  ),
  OnboardingModel(
  imagePath: "imagePath",
  title: 'Start Watching Now',
  subtitle: '',
  ),
  ];
}