import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../api/movie_api_service.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MovieApiService apiService;

  HomeBloc({required this.apiService}) : super(HomeInitial()) {
    on<FetchHomeData>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(
      FetchHomeData event,
      Emitter<HomeState> emit,
      ) async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        apiService.getMovies(limit: 5),
        apiService.getMovies(limit: 10, genre: 'Action'),
      ]);

      emit(HomeLoaded(
        carouselMovies: results[0],
        actionMovies: results[1],
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}