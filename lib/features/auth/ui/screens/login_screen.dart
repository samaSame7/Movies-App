import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/routing/app_router.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/features/profile/ui/tabs/profile_tab.dart';
import '../../../../core/app_assets/app_assets.dart';
import '../../../../core/widgets/app_dialogues.dart';
import '../../cubits/login/login_cubit.dart';
import '../../cubits/login/login_state.dart';
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
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginLoading) {
            showLoading(context);
          }

          if (state is LoginSuccess) {
            Navigator.pop(context);
            UserDM.currentUser =
                await getUserFromFirestore(state.user!.uid, state.user);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            );
          }

          if (state is LoginError) {
            Navigator.pop(context);

            showMessage(
              context,
              state.message,
              title: 'Error',
              posText: 'OK',
            );
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);

          return SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        AppAssets.appLogo,
                        height: MediaQuery.of(context).size.height * 0.25,
                      ),
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
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.forgetPasswordRoute);
                        },
                        child: const Text(
                          'Forget password?',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      CustomElevatedButton(
                        title: 'Login',
                        backgroundColor: AppColors.primary,
                        titleColor: AppColors.background,
                        onPressed: () {
                          cubit.login(
                            email: emailController.text,
                            password: passController.text,
                          );
                        },
                      ),
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
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textLight,
                              ),
                            ),
                            Text(
                              'Create one',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
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
                            child: Divider(
                              endIndent: 52,
                              color: AppColors.primary,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      CustomElevatedButton(
                        title: 'login with google',
                        onPressed: () {},
                        backgroundColor: AppColors.primary,
                        titleColor: AppColors.background,
                        icon: AppAssets.googleIcon,
                      ),
                      const SizedBox(height: 36),
                      const Align(
                        alignment: Alignment.center,
                        child: LanguageSwitch(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
