import 'package:bloc/bloc.dart';
import 'package:chatterly/domain/user_model.dart';
import 'package:chatterly/infrastructure/firebase_service.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseService _firebaseService;

  AuthBloc(this._firebaseService) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<SignOutEvent>(_onSignOut);
    on<AutoLoginEvent>(_onAutoLogin);
    on<LoadUserDataEvent>(_onLoadUserData);
  }

  Future<void> _onLoadUserData(
    LoadUserDataEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _firebaseService.getUserData(event.uid);
      emit(AuthSuccess(event.uid, user));
    } catch (e) {
      emit(AuthFailure('Failed to load user data: ${e.toString()}'));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      if (event.password != event.confirmPassword) {
        emit(AuthFailure('Passwords do not match'));
        return;
      }

      if (!isPasswordStrong(event.password)) {
        emit(AuthFailure('Password is not strong enough'));
        return;
      }

      await _firebaseService.registerUser(
        event.email,
        event.password,
        event.username,
      );
      final uid = _firebaseService.currentUser!.uid;
      final user = await _firebaseService.getUserData(uid);
      emit(AuthSuccess(uid, user));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Registration failed'));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseService.loginUser(event.email, event.password);
      final uid = _firebaseService.currentUser!.uid;
      final user = await _firebaseService.getUserData(uid);
      emit(AuthSuccess(uid, user));
      add(LoadUserDataEvent(user.uid));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Login failed'));
    }
  }

  Future<void> _onAutoLogin(
    AutoLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final user = _firebaseService.currentUser;
    if (user != null) {
      final userData = await _firebaseService.getUserData(user.uid);
      emit(AuthSuccess(user.uid, userData));
    } else {
      emit(AuthFailure('No user logged in'));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseService.signOutUser();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthFailure('Sign out failed'));
    }
  }

  bool isPasswordStrong(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[a-z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>-_]'))) return false;
    return true;
  }
}
