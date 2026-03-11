import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/api/movie_api_service.dart';
import '../../../home/ui/widgets/movie_poster_card.dart';
import '../../bloc/search_bloc.dart';
import '../../bloc/search_event.dart';
import '../../bloc/search_state.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(apiService: MovieApiService()),
      child: const SearchTabContent(),
    );
  }
}

class SearchTabContent extends StatefulWidget {
  const SearchTabContent({super.key});

  @override
  State<SearchTabContent> createState() => _SearchTabContentState();
}

class _SearchTabContentState extends State<SearchTabContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textLight),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  context.read<SearchBloc>().add(SearchMoviesEvent(value.trim()));
                } else {
                  context.read<SearchBloc>().add(ClearSearchEvent());
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.fieldFill,
                hintText: 'Search',
                hintStyle: const TextStyle(color: AppColors.textHint),
                prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textLight),
                  onPressed: () {
                    _searchController.clear();
                    context.read<SearchBloc>().add(ClearSearchEvent());
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return const Center(
                      child: Icon(Icons.local_movies_outlined, size: 100, color: AppColors.primary),
                    );
                  } else if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  } else if (state is SearchError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                  } else if (state is SearchLoaded) {
                    if (state.movies.isEmpty) {
                      return const Center(child: Text('No movies found.', style: TextStyle(color: Colors.white)));
                    }
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
}