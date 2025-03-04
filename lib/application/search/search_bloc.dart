import 'package:chatterly/domain/user_model.dart';
import 'package:chatterly/infrastructure/firebase_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final FirebaseService _firebaseService;

  SearchBloc(this._firebaseService) : super(SearchInitial()) {
    on<SearchUserEvent>((event, emit) async {
      emit(SearchLoading());
      try {
        final users = await _firebaseService.searchUsers(event.query).first;
        emit(SearchSuccess(users));
      } catch (e) {
        emit(SearchFailure(e.toString()));
      }
    });

    on<LoadAllUsersEvent>((event, emit) async {
      emit(SearchLoading());
      try {
        final users = await _firebaseService
            .getAllUsersExceptCurrent(event.currentUserId)
            .first;
        emit(SearchSuccess(users));
      } catch (e) {
        emit(SearchFailure(e.toString()));
      }
    });

     on<ClearSearchEvent>((event, emit) async {
      emit(SearchLoading());
      try {
        final users = await _firebaseService
            .getAllUsersExceptCurrent(event.currentUserId)
            .first;
        emit(SearchSuccess(users));
      } catch (e) {
        emit(SearchFailure(e.toString()));
      }
    });
  }
}
