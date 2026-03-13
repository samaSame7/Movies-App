import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/app_assets/app_assets.dart';
import '../../../../core/theme/app_colors.dart';

class LanguageSwitch extends StatefulWidget {
  const LanguageSwitch({super.key});

  @override
  State<LanguageSwitch> createState() => _LanguageSwitchState();
}

class _LanguageSwitchState extends State<LanguageSwitch> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isEnglish = !isEnglish),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 120,
        height: 55,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _FlagItem(
              imagePath: AppAssets.egyptFlag,
              isSelected: isEnglish,
            ),
            _FlagItem(
              imagePath:AppAssets.lrFlag,
              isSelected: !isEnglish,
            ),
          ],
        ),
      ),);
  }
}
class _FlagItem extends StatelessWidget {
  final String imagePath;
  final bool isSelected;

  const _FlagItem({required this.imagePath, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 4,
        ),
      ),
      child: ClipOval(
        child: SvgPicture.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
