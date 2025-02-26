part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchUserEvent extends SearchEvent {
  final String query;

  const SearchUserEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ToggleSearchEvent extends SearchEvent {}
