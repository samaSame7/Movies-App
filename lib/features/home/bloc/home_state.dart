import 'package:equatable/equatable.dart';
import '../models/movie_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<MovieModel> carouselMovies;
  final List<MovieModel> actionMovies;

  const HomeLoaded({required this.carouselMovies, required this.actionMovies});

  @override
  List<Object> get props => [carouselMovies, actionMovies];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
