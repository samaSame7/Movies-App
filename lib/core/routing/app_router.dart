import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../features/splash/ui/screens/splash_screen.dart';
import '../../features/onboarding/ui/screens/onboarding_screen.dart';
import '../../features/auth/ui/screens/login_screen.dart';
import '../../features/auth/ui/screens/register_screen.dart';
import '../../features/main_layout/ui/screens/main_layout_screen.dart';
import '../../features/movie_details/ui/screens/movie_details_screen.dart';
import '../theme/app_colors.dart';

abstract class AppRouter {
  static Route generateRoute(RouteSettings settings) {
    if (kDebugMode) {
      print('Navigating to: ${settings.name}');
    }

    final uri = Uri.parse(settings.name ?? '/');

    switch (uri.path) {
      case Routes.splashRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case Routes.onboardingRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OnboardingScreen(),
        );

      case Routes.loginRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );

      case Routes.registerRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegisterScreen(),
        );

      case Routes.mainLayoutRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainLayoutScreen(),
        );

      case Routes.movieDetailsRoute:
        final movieId = settings.arguments as int? ?? 0;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MovieDetailsScreen(movieId: movieId),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            backgroundColor: AppColors.background,
            body: const Center(
              child: Text(
                '404 - Page Not Found',
                style: TextStyle(color: AppColors.textLight, fontSize: 18),
              ),
            ),
          ),
        );
    }
  }
}

abstract class Routes {
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String mainLayoutRoute = '/mainLayout';
  static const String movieDetailsRoute = '/movieDetails';
}
