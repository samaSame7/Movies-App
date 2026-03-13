import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movies_app/core/routing/app_router.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/features/profile/ui/tabs/profile_tab.dart';

import '../../../../core/app_assets/app_assets.dart';
import '../../../../core/widgets/app_dialogues.dart';
import '../../firebase_utility.dart';
import '../../user_dm.dart';
import '../widgets/language_switch.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(AppAssets.appLogo, height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.25,),
                CustomTextField(
                  hintText: 'Enter your email',
                  controller: emailController,
                  prefixIcon: AppAssets.emailIcon,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Enter your password',
                  controller: passController,
                  prefixIcon: AppAssets.passIcon,
                  isPassword: true,
                ),
                InkWell(onTap: (){
                  Navigator.pushNamed(context, Routes.forgetPasswordRoute);
                },
                  child: const Text('Forget password?',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary)),
                ),
                const SizedBox(height: 36),
                buildCustomElevatedButton(),
                const SizedBox(height: 24),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.registerRoute);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dont have an account? ',
                        style: TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textLight),
                      ),
                      Text(
                        'Create one',
                        style: TextStyle(fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        indent: 52,
                        color: AppColors.primary,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(endIndent: 52,
                        color: AppColors.primary,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                CustomElevatedButton(
                  title: 'login with google',
                  onPressed: () async {},
                  backgroundColor: AppColors.primary,
                  titleColor: AppColors.background,
                  icon: AppAssets.googleIcon,

                ),
                const SizedBox(height: 36,),
                const Align(alignment: Alignment.center,
                    child: LanguageSwitch()),

              ],
            ),
          ),
        ),
      ),
    );
  }

  CustomElevatedButton buildCustomElevatedButton() {
    return CustomElevatedButton(onPressed: ()async {
      try {
        showLoading(context);
        final credential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passController.text,
        );
        UserDM.currentUser =
        await getUserFromFirestore(credential.user!.uid, credential.user);
        print("user email: ${UserDM.currentUser?.email}");
        Navigator.pop(context);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfileScreen()));
        // Navigator.push(context, AppRoutes.navigation);
    } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        var message = '';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        } else {
          message = e.message ?? "Something went wrong please try again later";
        }
        showMessage(context, message, title: 'error', posText: 'ok');
      } catch (e) {
        showMessage(context,"Something went wrong please try again later",
            title: 'error', posText: 'ok');
      }
    },
                  title: 'Login',
                  backgroundColor: AppColors.primary,
                  titleColor: AppColors.background);
  }
}

