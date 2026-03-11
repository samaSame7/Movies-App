import 'package:equatable/equatable.dart';
import '../models/movie_details_model.dart';
import '../../home/models/movie_model.dart';

abstract class MovieDetailsState extends Equatable {
  const MovieDetailsState();
  @override
  List<Object> get props => [];
}

class MovieDetailsInitial extends MovieDetailsState {}
class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final MovieDetailsModel details;
  final List<MovieModel> suggestions;

  const MovieDetailsLoaded({required this.details, required this.suggestions});

  @override
  List<Object> get props => [details, suggestions];
}

class MovieDetailsError extends MovieDetailsState {
  final String message;
  const MovieDetailsError(this.message);
  @override
  List<Object> get props => [message];
}