import 'package:equatable/equatable.dart';

import '../../home/models/movie_model.dart';

abstract class BrowseState extends Equatable {
  @override
  List<Object> get props => [];
}

class BrowseInitial extends BrowseState {}

class BrowseLoading extends BrowseState {}

class BrowseLoaded extends BrowseState {
  final List<String> genres;
  final String selectedGenre;
  final List<MovieModel> movies;

  BrowseLoaded({
    required this.genres,
    required this.selectedGenre,
    required this.movies,
  });

  @override
  List<Object> get props => [genres, selectedGenre, movies];
}

class BrowseError extends BrowseState {
  final String message;
  BrowseError(this.message);
  @override
  List<Object> get props => [message];
}
