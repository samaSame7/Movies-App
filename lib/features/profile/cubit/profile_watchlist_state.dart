import 'package:equatable/equatable.dart';

import '../../home/models/movie_model.dart';

abstract class ProfileWatchState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileWatchState {}

class ProfileLoading extends ProfileWatchState {}

class ProfileLoaded extends ProfileWatchState {
  final List<MovieModel> watchList;
  final List<MovieModel> history;

  ProfileLoaded({required this.watchList, required this.history});

  @override
  List<Object> get props => [watchList, history];
}

class ProfileError extends ProfileWatchState {
  final String message;
  ProfileError(this.message);
  @override
  List<Object> get props => [message];
}
