import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/api/movie_api_service.dart';
import '../../../home/ui/widgets/movie_poster_card.dart';
import '../../bloc/browse_bloc.dart';
import '../../bloc/browse_event.dart';
import '../../bloc/browse_state.dart';

class BrowseTab extends StatelessWidget {
  const BrowseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BrowseBloc(apiService: MovieApiService())
            ..add(InitializeBrowseEvent()),
      child: const BrowseTabContent(),
    );
  }
}

class BrowseTabContent extends StatelessWidget {
  const BrowseTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<BrowseBloc, BrowseState>(
        builder: (context, state) {
          if (state is BrowseLoading || state is BrowseInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is BrowseError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is BrowseLoaded) {
            return Column(
              children: [
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.genres.length,
                    itemBuilder: (context, index) {
                      final genre = state.genres[index];
                      final isSelected = state.selectedGenre == genre;

                      return GestureDetector(
                        onTap: () {
                          if (!isSelected) {
                            context.read<BrowseBloc>().add(
                              SelectGenreEvent(genre),
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              genre,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.black
                                    : AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Expanded(
                  child: state.movies.isEmpty
                      ? const Center(
                          child: Text(
                            'No movies in this genre.',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.65,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: state.movies.length,
                          itemBuilder: (context, index) {
                            return MoviePosterCard(
                              movie: state.movies[index],
                              width: double.infinity,
                              height: double.infinity,
                            );
                          },
                        ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
