import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movies_app/core/app_assets/app_assets.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/features/auth/ui/screens/login_screen.dart';
import 'package:movies_app/features/auth/user_dm.dart';

class ProfileScreen extends StatefulWidget {


  const ProfileScreen({super.key,});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(color: AppColors.fieldFill,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14,),

                      Row(
                        children: [
                          CircleAvatar(
                            radius: 42,
                            child: Image.asset(UserDM.currentUser!.profilePhoto),
                          ),
                          const SizedBox(width: 24),

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _StatColumn(
                                  count: UserDM.currentUser?.wishListCount ?? 0,
                                  label: 'Wish List',
                                ),
                                _StatColumn(
                                  count: UserDM.currentUser?.historyCount ?? 0,
                                  label: 'History',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),


                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          UserDM.currentUser!.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                          children: [Expanded(
                              child: CustomElevatedButton(
                                onPressed: () {

                                },
                                title:
                                'Edit Profile',
                                backgroundColor: AppColors.primary,
                                titleColor: AppColors.background,
                              )
                          ),

                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: const Color(0xFF1A1A1A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text(
                                'Exit',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                              content: const Text(
                                'Are you sure you want to logout?',
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
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                                          (route) => false,
                                    );
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
                          );                },

                        label: const Text('Exit',style: TextStyle(color: Colors.white),),
                        icon: const Icon(Icons.logout, size: 18,color: Colors.white,),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.red,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _TabItem(
                          icon: Icons.list,
                          label: 'Watch List',
                          selected: _selectedTab == 0,
                          onTap: () => setState(() => _selectedTab = 0),
                          activeColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 32),
                      Expanded(
                        child: _TabItem(
                          icon: Icons.folder,
                          label: 'History',
                          selected: _selectedTab == 1,
                          onTap: () => setState(() => _selectedTab = 1),
                          activeColor: AppColors.primary,
                        ),
                      ),
                    ],
                  ),



                  ],
                          ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(AppAssets.popCorn),
              ),
            ],
          ),
      ),
    ),);
  }
}


class _StatColumn extends StatelessWidget {
  final int count;
  final String label;

  const _StatColumn({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color activeColor;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: selected ? activeColor : Colors.white54,
            size: 35,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white54,
              fontWeight:
              selected ? FontWeight.w700 : FontWeight.w400,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          if (selected)
            Container(
              height: 2.5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}

