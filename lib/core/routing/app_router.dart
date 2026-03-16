import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/features/auth/ui/screens/forget_password.dart';
import 'package:movies_app/features/auth/ui/screens/register_screen.dart';
import 'package:movies_app/features/onboarding/ui/screens/onboarding_screen.dart';
import 'package:movies_app/features/profile/ui/update_profile.dart';
import '../../features/auth/ui/screens/login_screen.dart';
import '../../features/splash/ui/screens/splash_screen.dart';

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

      case Routes.loginRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case Routes.onboardingRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OnboardingScreen(),
        );
      case Routes.registerRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegisterScreen(),
        );
      case Routes.forgetPasswordRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ForgetPassword(),
        );
      case Routes.updateProfileRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const UpdateProfile(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
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
  static const String forgetPasswordRoute = '/forgetPassword';
  static const String updateProfileRoute = '/updateProfile';


}
