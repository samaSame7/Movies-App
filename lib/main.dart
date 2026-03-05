import 'package:flutter/material.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/main_layout/ui/screens/main_layout_screen.dart';

void main() {
  runApp(const MyApp());
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
      home: const MainLayoutScreen(),
    );
  }
}
