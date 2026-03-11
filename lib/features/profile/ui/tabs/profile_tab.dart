import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/profile/ui/screens/edit_profile_screen.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/ui/widgets/movie_poster_card.dart';
import '../../api/profile_api_service.dart';
import '../../bloc/profile_bloc.dart';
import '../../bloc/profile_event.dart';
import '../../bloc/profile_state.dart';
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

class ProfileTabContent extends StatelessWidget {
  const ProfileTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  int watchListCount = 0;
                  int historyCount = 0;

                  if (state is ProfileLoaded) {
                    watchListCount = state.watchList.length;
                    historyCount = state.history.length;
                  }

                  return Row(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.fieldFill,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sama Sameh',
                              style: TextStyle(
                                color: AppColors.textLight,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfileScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      icon: const Text(
                        'Exit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      label: const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
              child: BlocBuilder<ProfileBloc, ProfileState>(
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
}
