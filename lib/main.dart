import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/splash/ui/screens/splash_screen.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/api/auth_api_service.dart';
import 'features/auth/bloc/auth_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => AuthBloc(authApiService: AuthApiService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      initialRoute: Routes.splashRoute,
      title: 'Route Movies',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
