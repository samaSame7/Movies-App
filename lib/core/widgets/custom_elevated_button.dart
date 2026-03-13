import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies_app/core/theme/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton(
      {super.key,
      required this.title,
      required this.backgroundColor,
      this.onPressed,
      required this.titleColor, this.icon});

  final String title;
  final Color backgroundColor;
  final void Function()? onPressed;
  final Color titleColor;
final String? icon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: AppColors.primary),
          backgroundColor: backgroundColor,
          foregroundColor: titleColor,

          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: onPressed,
        child:  icon != null
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon!,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(color: titleColor,fontSize: 16),
            ),
          ],
        )
            :Text(
          title,
          style: TextStyle(color: titleColor,fontSize: 16),
        ));
  }
}
