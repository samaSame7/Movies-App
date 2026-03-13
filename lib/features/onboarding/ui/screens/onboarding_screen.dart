import 'package:flutter/material.dart';
import 'package:movies_app/core/routing/app_router.dart';
import 'package:movies_app/core/theme/app_colors.dart';

import '../../../../core/widgets/custom_elevated_button.dart';
import '../../models/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: onboardingList.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        onboardingList[index].image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            onboardingList[index].title,
                            style: const TextStyle(
                              color: AppColors.textLight,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (onboardingList[index].description != null &&
                              onboardingList[index].description!.isNotEmpty)
                            Text(
                              onboardingList[index].description!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textHint,
                              ),
                            ),
                          const SizedBox(height: 20),
                          CustomElevatedButton(
                            onPressed: () {
                              if (currentIndex < onboardingList.length - 1) {
                                controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              } else {
                                Navigator.pushNamed(context, Routes.loginRoute);
                              }
                            },
                            title: currentIndex == onboardingList.length - 1
                                ? "Finish"
                                : currentIndex == 0
                                    ? 'Explore now'
                                    : "Next",
                            titleColor: Colors.black,
                            backgroundColor: AppColors.primary,
                          ),
                          const SizedBox(height: 10),
                          if (currentIndex > 1)
                            CustomElevatedButton(
                              onPressed: () {
                                controller.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                              title: "Back",
                              backgroundColor: AppColors.background,
                              titleColor: AppColors.primary,
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
