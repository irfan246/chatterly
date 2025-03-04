import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_animation_event.dart';
part 'search_animation_state.dart';

class SearchAnimationBloc
    extends Bloc<SearchAnimationEvent, SearchAnimationState> {
  SearchAnimationBloc() : super(SearchAnimationInitial()) {
    on<ToggleSearchAnimation>((event, emit) {
      if (state is SearchAnimationInactive) {
        emit(SearchAnimationActive());
      } else {
        emit(SearchAnimationInactive());
      }
    });
  }
}
