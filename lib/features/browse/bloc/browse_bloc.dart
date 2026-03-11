import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/api/movie_api_service.dart';
import 'browse_event.dart';
import 'browse_state.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final MovieApiService apiService;
  List<String> _cachedGenres = [];

  BrowseBloc({required this.apiService}) : super(BrowseInitial()) {
    on<InitializeBrowseEvent>((event, emit) async {
      emit(BrowseLoading());
      try {
        final initialMovies = await apiService.getMovies(limit: 50);

        Set<String> genreSet = {};
        for (var movie in initialMovies) {
          genreSet.addAll(movie.genres);
        }

        _cachedGenres = genreSet.toList()..sort();

        if (_cachedGenres.isEmpty) {
          _cachedGenres = ['Action', 'Comedy', 'Drama'];
        }

        final String initialGenre = _cachedGenres.first;
        final moviesForGenre = await apiService.getMovies(genre: initialGenre, limit: 30);

        emit(BrowseLoaded(
          genres: _cachedGenres,
          selectedGenre: initialGenre,
          movies: moviesForGenre,
        ));
      } catch (e) {
        emit(BrowseError(e.toString()));
      }
    });

    on<SelectGenreEvent>((event, emit) async {
      if (state is BrowseLoaded) {
        emit(BrowseLoading());
        try {
          final moviesForGenre = await apiService.getMovies(genre: event.genre, limit: 30);
          emit(BrowseLoaded(
            genres: _cachedGenres,
            selectedGenre: event.genre,
            movies: moviesForGenre,
          ));
        } catch (e) {
          emit(BrowseError(e.toString()));
        }
      }
    });
  }
}