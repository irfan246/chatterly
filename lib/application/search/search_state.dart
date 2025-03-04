part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<UserModel> users;

  const SearchSuccess(this.users);

  @override
  List<Object> get props => [users];
}

class SearchFailure extends SearchState {
  final String error;

  const SearchFailure(this.error);

  @override
  List<Object> get props => [error];
}
