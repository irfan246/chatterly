part of 'search_animation_bloc.dart';

abstract class SearchAnimationEvent extends Equatable {
  const SearchAnimationEvent();

  @override
  List<Object> get props => [];
}

class ToggleSearchAnimationEvent extends SearchAnimationEvent {}
