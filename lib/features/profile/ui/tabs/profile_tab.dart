import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/routing/app_router.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/core/widgets/custom_elevated_button.dart';
import 'package:movies_app/features/auth/ui/screens/login_screen.dart';
import 'package:movies_app/features/auth/user_dm.dart';

import '../../../home/ui/widgets/movie_poster_card.dart';
import '../../api/profile_api_service.dart';
import '../../cubit/profile_bloc.dart';
import '../../cubit/profile_event.dart';
import '../../cubit/profile_watchlist_state.dart';
import '../../services/history_service.dart';
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        apiService: ProfileApiService(),
        historyService: HistoryService(),
      )..add(FetchProfileData(token: 'YOUR_CACHED_TOKEN_HERE')),
      child: const ProfileTabContent(),
    );
  }
}
class ProfileTabContent extends StatefulWidget {
  const ProfileTabContent({
    super.key,
  });

  @override
  State<ProfileTabContent> createState() => _ProfileTabContentState();
}

class _ProfileTabContentState extends State<ProfileTabContent> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
      child: DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: BlocBuilder<ProfileBloc, ProfileWatchState>(
              builder: (context, state) {
                int watchListCount = 0;
                int historyCount = 0;

                if (state is ProfileLoaded) {
                  watchListCount = state.watchList.length;
                  historyCount = state.history.length;
                }

                return Row(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      child:
                      Image.asset(UserDM.currentUser!.profilePhoto),
                    ),                      const SizedBox(width: 16),
                     Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(left: 8.0),
                            child: Text(
                              UserDM.currentUser!.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatColumn(watchListCount.toString(), 'Wish List'),
                    const SizedBox(width: 20),
                    _buildStatColumn(historyCount.toString(), 'History'),
                  ],
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                    child: CustomElevatedButton(
                      onPressed: () async{
                        final result = await Navigator.pushNamed(
                            context, Routes.updateProfileRoute);
                        if (result == true) {
                          setState(() {});
                        }
                      },
                      title: 'Edit Profile',
                      backgroundColor: AppColors.primary,
                      titleColor: AppColors.background,
                    )),
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
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                        content: const Text(
                          'Are you sure you want to logout?',
                          style: TextStyle(color: Colors.white70),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel',
                                style:
                                TextStyle(color: Colors.white54)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                    const LoginScreen()),
                                    (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFFD32F2F),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('OK',
                                style:
                                TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  },
                  label: const Text(
                    'Exit',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.logout,
                    size: 18,
                    color: Colors.white,
                  ),
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
            ),            ),
          const SizedBox(height: 20),
          const TabBar(
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.textLight,
            unselectedLabelColor: AppColors.textHint,
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Watch List'),
              Tab(icon: Icon(Icons.folder), text: 'History'),
            ],
          ),

          Expanded(
            child: BlocBuilder<ProfileBloc, ProfileWatchState>(
              builder: (context, state) {
                if (state is ProfileLoading || state is ProfileInitial) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                } else if (state is ProfileError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is ProfileLoaded) {
                  return TabBarView(
                    children: [
                      _buildMovieGrid(
                        state.watchList,
                        "Your watch list is empty.",
                      ),
                      _buildMovieGrid(
                        state.history,
                        "You haven't viewed any movies yet.",
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    ),
    )
    );
  }
  Widget _buildMovieGrid(List movies, String emptyMessage) {
    if (movies.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.65,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MoviePosterCard(
          movie: movies[index],
          width: double.infinity,
          height: double.infinity,
        );
      },
    );
  }
  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.textLight, fontSize: 14),
        ),
      ],
    );
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
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
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
