part of 'search_animation_bloc.dart';

abstract class SearchAnimationState extends Equatable {
  const SearchAnimationState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchAnimationState {}

class SearchActive extends SearchAnimationState {}

class SearchInactive extends SearchAnimationState {}
