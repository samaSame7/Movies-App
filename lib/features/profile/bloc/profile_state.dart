import 'package:equatable/equatable.dart';

import '../../home/models/movie_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final List<MovieModel> watchList;
  final List<MovieModel> history;

  ProfileLoaded({required this.watchList, required this.history});

  @override
  List<Object> get props => [watchList, history];
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
  @override
  List<Object> get props => [message];
}
