import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/app_assets/app_assets.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';
import 'package:movies_app/features/auth/ui/widgets/avatar_selector.dart';
import 'package:movies_app/features/auth/ui/widgets/language_switch.dart';
import '../../../profile/ui/tabs/profile_tab.dart';
import '../../cubits/register/register_cubit.dart';
import '../../cubits/register/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  int selectedAvatarIndex = 0;
  final formKey = GlobalKey<FormState>();

  final List<String> avatars = [
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
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is RegisterSuccess) {


            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileTabContent(),
              ),
            );
          }
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);

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
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
                        const Text('Avatar',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 16)),
                        const SizedBox(height: 6),
                        CustomTextField(
                          controller: nameController,
                          hintText: 'Name',
                          prefixIcon: AppAssets.nameIcon,
                        ),
                        CustomTextField(
                          hintText: 'Email',
                          controller: emailController,
                          prefixIcon: AppAssets.emailIcon,
                        ),
                        CustomTextField(
                          hintText: 'Password',
                          isPassword: true,
                          controller: passController,
                          prefixIcon: AppAssets.passIcon,
                        ),
                        CustomTextField(
                          hintText: 'Confirm Password',
                          isPassword: true,
                          controller: confirmPassController,
                          prefixIcon: AppAssets.confirmPassIcon,
                        ),
                        CustomTextField(
                          hintText: 'Phone number',
                          controller: phoneController,
                          prefixIcon: AppAssets.phoneIcon,
                        ),
                        const SizedBox(height: 16),
                        state is RegisterLoading
                            ? const CircularProgressIndicator()
                            : CustomElevatedButton(
                          title: 'Create account',
                          backgroundColor: AppColors.primary,
                          titleColor: AppColors.background,
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;
                            if (passController.text !=
                                confirmPassController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Passwords do not match")),
                              );
                              return;
                            }

                            cubit.register(
                              name: nameController.text,
                              email: emailController.text,
                              password: passController.text,
                              phone: phoneController.text,
                              avatar: avatars[selectedAvatarIndex],
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () => Navigator.pop(context),
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
                        const SizedBox(height: 12),
                        const LanguageSwitch(),
                      ],
                    ),
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
