import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';
import '../../home/api/movie_api_service.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final MovieApiService apiService;

  MovieDetailsBloc({required this.apiService}) : super(MovieDetailsInitial()) {
    on<FetchMovieDetails>(_onFetchMovieDetails);
  }

  Future<void> _onFetchMovieDetails(
      FetchMovieDetails event,
      Emitter<MovieDetailsState> emit,
      ) async {
    emit(MovieDetailsLoading());
    try {
      final results = await Future.wait([
        apiService.getMovieDetails(event.movieId),
        apiService.getMovieSuggestions(event.movieId),
      ]);

      emit(MovieDetailsLoaded(
        details: results[0] as dynamic,
        suggestions: results[1] as dynamic,
      ));
    } catch (e) {
      emit(MovieDetailsError(e.toString()));
    }
  }
}