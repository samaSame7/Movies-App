import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/app_assets/app_assets.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/core/widgets/custom_text_field.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/firebase_utility.dart';
import '../../auth/user_dm.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  late TextEditingController controller;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    controller =
        TextEditingController(text: UserDM.currentUser!.name);

    phoneController =
        TextEditingController(text: UserDM.currentUser!.phoneNumber);
  }

  @override
  void dispose() {
    controller.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: BlocConsumer<ProfileCubit, ProfileState>(

        listener: (context, state) {

          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }

          if (state is ProfileSuccess) {
            Navigator.pop(context, true);          }

        },

        builder: (context, state) {

          var cubit = ProfileCubit.get(context);

          return Scaffold(
            backgroundColor: AppColors.background,

            appBar: AppBar(
              backgroundColor: AppColors.background,
              centerTitle: true,
              title: const Text(
                'Pick Avatar',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                ),
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

            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 20),

                          InkWell(
                            onTap: () =>
                                showAvatarPicker(context, cubit),
                            child: Center(
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                AssetImage(cubit.selectedAvatar),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          CustomTextField(
                            hintText: "Name",
                            prefixIcon: AppAssets.nameIcon,
                            controller: controller,
                          ),

                          const SizedBox(height: 12),

                          CustomTextField(
                            hintText: 'Mobile number',
                            prefixIcon: AppAssets.phoneIcon,
                            controller: phoneController,
                          ),

                          const SizedBox(height: 16),

                          const Text(
                            'Reset Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Column(
                    children: [

                      CustomElevatedButton(
                        title: 'Delete Account',
                        backgroundColor: AppColors.red,
                        titleColor: Colors.white,
                        onPressed: () {
                          confirmAndDeleteAccount(context);

                        },
                      ),

                      const SizedBox(height: 12),

                      state is ProfileLoading
                          ? const CircularProgressIndicator()
                          : CustomElevatedButton(
                        title: 'Update Data',
                        backgroundColor: AppColors.primary,
                        titleColor: Colors.black,
                        onPressed: () {

                          cubit.updateUserData(
                            name: controller.text,
                            phone: phoneController.text,
                            avatar: cubit.selectedAvatar,
                          );

                        },
                      ),

                      const SizedBox(height: 12),

                    ],
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showAvatarPicker(BuildContext context, ProfileCubit cubit) {

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.fieldFill,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,

          child: GridView.builder(
            padding: const EdgeInsets.all(20),

            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),

            itemCount: cubit.avatars.length,

            itemBuilder: (context, index) {

              final avatar = cubit.avatars[index];

              return GestureDetector(
                onTap: () {

                  cubit.changeAvatar(avatar);

                  Navigator.pop(context);

                },

                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),

                    border: Border.all(
                      color: cubit.selectedAvatar == avatar
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 3,
                    ),

                    color: cubit.selectedAvatar == avatar
                        ? AppColors.primary.withOpacity(0.3)
                        : Colors.transparent,
                  ),

                  child: CircleAvatar(
                    backgroundImage: AssetImage(avatar),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> confirmAndDeleteAccount(BuildContext context) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Account',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              deleteAccount(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}