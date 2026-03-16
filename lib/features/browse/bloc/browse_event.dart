import 'package:equatable/equatable.dart';

abstract class BrowseEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitializeBrowseEvent extends BrowseEvent {}

class SelectGenreEvent extends BrowseEvent {
  final String genre;
  SelectGenreEvent(this.genre);
  @override
  List<Object> get props => [genre];
}
