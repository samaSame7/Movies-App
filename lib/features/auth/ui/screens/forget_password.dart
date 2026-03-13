import 'package:flutter/material.dart';
import 'package:movies_app/core/app_assets/app_assets.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';

import '../../../../core/widgets/app_dialogues.dart';
import '../../firebase_utility.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          centerTitle: true,
          title: const Text(
            'Forget Password',
            style: TextStyle(fontSize: 16, color: AppColors.primary),
          ),
          leading: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.primary,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  AppAssets.forgetPass,
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
                const SizedBox(
                  height: 12,
                ),
                 CustomTextField(hintText: 'Email', prefixIcon: AppAssets.emailIcon,controller: emailController,),
                const SizedBox(height: 16,),
                CustomElevatedButton(
                    title: 'Verify Email',
                    backgroundColor: AppColors.primary,
                    titleColor: AppColors.background,onPressed: (){
                  String email = emailController.text.trim();
                  if(email.isEmpty) {
                    showMessage(context, "الرجاء إدخال البريد الإلكتروني", title: "خطأ", posText: "OK");
                  } else {
                    verifyEmailAndResetPassword(context, email);
                    Navigator.pop(context);
                  }
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
