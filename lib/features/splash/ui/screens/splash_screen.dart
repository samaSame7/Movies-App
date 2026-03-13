import 'package:flutter/material.dart';
import 'package:movies_app/core/app_assets/app_assets.dart';
import 'package:movies_app/core/theme/app_colors.dart';

import '../../../../core/routing/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushNamed(context, Routes.onboardingRoute);
      }    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: AppColors.background,
      body: Column(
        children: [
          const Expanded(child: SizedBox()),
          Expanded(child: Image.asset(AppAssets.appLogo)),
          Expanded(child: Image.asset(AppAssets.routeLogo))
        ],
      )
    );
  }
}
