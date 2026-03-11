import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/models/movie_model.dart';
import '../api/profile_api_service.dart';
import '../services/history_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileApiService apiService;
  final HistoryService historyService;

  ProfileBloc({required this.apiService, required this.historyService})
    : super(ProfileInitial()) {
    on<FetchProfileData>((event, emit) async {
      emit(ProfileLoading());
      try {
        final results = await Future.wait([
          apiService.getWatchlist(event.token),
          historyService.getHistory(),
        ]);

        emit(
          ProfileLoaded(
            watchList: results[0] as List<MovieModel>,
            history: results[1] as List<MovieModel>,
          ),
        );
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
