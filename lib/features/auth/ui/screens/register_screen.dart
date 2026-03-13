import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/core/app_assets/app_assets.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/features/auth/ui/widgets/avatar_selector.dart';
import 'package:movies_app/features/auth/ui/widgets/language_switch.dart';

import '../../../../core/widgets/app_dialogues.dart';
import '../../firebase_utility.dart';
import '../../user_dm.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();

  final passController = TextEditingController();

  final nameController = TextEditingController();

  final phoneController = TextEditingController();
  int selectedAvatarIndex = 0;
  var formKey = GlobalKey<FormState>();
  List<String> avatars = [
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar7,
    AppAssets.avatar8,
    AppAssets.avatar9
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          centerTitle: true,
          title: const Text(
            'Register',
            style: TextStyle(fontSize: 16, color: AppColors.primary),
          ),
          leading: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: AppColors.primary,
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  AvatarSelector(
                    avatars: avatars,
                    onAvatarSelected: (index) {
                      setState(() {
                        selectedAvatarIndex = index;
                      });
                    },
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Avatar',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  CustomTextField(
                      controller: nameController,
                      validator: (text) {
                        if (text?.isEmpty == true)
                          return "Please enter valid name";
                        return null;
                      },
                      hintText: 'Name',
                      prefixIcon: AppAssets.nameIcon),
                  CustomTextField(
                    hintText: 'Email',
                    prefixIcon: AppAssets.emailIcon,
                    controller: emailController,
                    validator: (text) {
                      if (text?.isEmpty == true) return "Please valid email";
                      var isValid = RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(text!);
                      if (!isValid) return "this email is in invalid form";
                      return null;
                    },
                  ),
                  CustomTextField(
                    hintText: 'Password',
                    isPassword: true,
                    prefixIcon: AppAssets.passIcon,
                    controller: passController,
                    validator: (text) {
                      if (text == null || text.isEmpty == true) {
                        return "Please enter valid password";
                      }
                      if (text.length < 6) {
                        return "Your password is weak";
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                      isPassword: true,
                      validator: (text) {
                        if (text == null || text.isEmpty == true) {
                          return "Please enter valid password";
                        }
                        if (text != passController.text) {
                          return "Password does not match";
                        }
                        return null;
                      },
                      hintText: 'Confirm Password',
                      prefixIcon: AppAssets.confirmPassIcon),
                  CustomTextField(
                      hintText: 'Phone number',
                      controller: phoneController,
                      validator: (text) {
                        if (text?.isEmpty == true || text!.length < 11) {
                          return "Please valid phone number";
                        }
                        return null;
                      },
                      prefixIcon: AppAssets.phoneIcon),
                  buildCustomElevatedButton(),
                  const SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textLight),
                        ),
                        Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const LanguageSwitch(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CustomElevatedButton buildCustomElevatedButton() {
    return CustomElevatedButton(
        onPressed: () async {
          if (!formKey.currentState!.validate()) return;

          try {
            showLoading(context);
            final credential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: emailController.text,
              password: passController.text,
            );
            UserDM.currentUser = UserDM(
              id: credential.user!.uid,
              name: nameController.text,
              email: emailController.text,
              phoneNumber: phoneController.text,
              profilePhoto: avatars[selectedAvatarIndex],
            );

            createUserInFirestore(UserDM.currentUser!);
            Navigator.pop(context);
            // Navigator.push(context, AppRoutes.navigation);
          } on FirebaseAuthException catch (e) {
            Navigator.pop(context);
            var message = '';
            if (e.code == 'weak-password') {
              message = 'The password provided is too weak.';
            } else if (e.code == 'email-already-in-use') {
              message = 'The account already exists for that email.';
            } else {
              message =
                  e.message ?? "Something went wrong please try again later";
            }
            showMessage(context, message, title: 'error', posText: 'ok');
          } catch (e) {
            showMessage(context, "Something went wrong please try again later",
                title: 'error', posText: 'ok');
          }
        },
        title: 'Create account',
        backgroundColor: AppColors.primary,
        titleColor: AppColors.background);
  }
}
