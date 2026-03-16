import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../api/movie_api_service.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_event.dart';
import '../../bloc/home_state.dart';
import '../../models/movie_model.dart';
import '../widgets/movie_poster_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(apiService: MovieApiService())..add(FetchHomeData()),
      child: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            } else if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<HomeBloc>().add(FetchHomeData()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is HomeLoaded) {
              return _buildContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeLoaded state) {
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Center(
              child: Text(
                'Available Now',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildAvailableMovies(state, size),
          const Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
            child: Center(
              child: Text(
                'Watch Now',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildGenreSection('Action', state.actionMovies),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildAvailableMovies(HomeLoaded state, Size size) {
    return CarouselSlider.builder(
      itemCount: state.carouselMovies.length,
      itemBuilder: (context, index, realIndex) {
        return MoviePosterCard(
          movie: state.carouselMovies[index],
          width: double.infinity,
          height: double.infinity,
        );
      },
      options: CarouselOptions(
        height: size.height * 0.45,
        viewportFraction: 0.65,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        enableInfiniteScroll: true,
      ),
    );
  }

  Widget _buildGenreSection(String title, List<MovieModel> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Text(
                      'See More ',
                      style: TextStyle(color: AppColors.primary, fontSize: 14),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MoviePosterCard(movie: movies[index]);
            },
          ),
        ),
      ],
    );
  }
}
