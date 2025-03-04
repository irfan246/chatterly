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

class LoadAllUsersEvent extends SearchEvent {
  final String currentUserId;

  const LoadAllUsersEvent(this.currentUserId);

  @override
  List<Object> get props => [currentUserId];
}

class ClearSearchEvent extends SearchEvent {
  final String currentUserId;

  const ClearSearchEvent(this.currentUserId);

  @override
  List<Object> get props => [currentUserId];
}
