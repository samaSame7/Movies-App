import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/api/movie_api_service.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final MovieApiService apiService;

  SearchBloc({required this.apiService}) : super(SearchInitial()) {
    on<SearchMoviesEvent>((event, emit) async {
      emit(SearchLoading());
      try {
        final movies = await apiService.searchMovies(event.query);
        emit(SearchLoaded(movies));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });

    on<ClearSearchEvent>((event, emit) {
      emit(SearchInitial());
    });
  }
}
