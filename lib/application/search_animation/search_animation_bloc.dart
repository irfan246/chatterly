import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_animation_event.dart';
part 'search_animation_state.dart';

class SearchAnimationBloc extends Bloc<SearchAnimationEvent, SearchAnimationState> {
  SearchAnimationBloc() : super(SearchInactive()) {
    on<ToggleSearchAnimationEvent>((event, emit) {
      if (state is SearchInactive) {
        emit(SearchActive());
      } else {
        emit(SearchInactive());
      }
    });
  }
}
