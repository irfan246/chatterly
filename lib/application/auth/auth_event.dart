part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String username;
  final String password;
  final String confirmPassword;

  const RegisterEvent({
    required this.email,
    required this.username,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [email, username, password, confirmPassword];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignOutEvent extends AuthEvent {}

class AutoLoginEvent extends AuthEvent {}

class LoadUserDataEvent extends AuthEvent {
  final String uid;

  LoadUserDataEvent(this.uid);

  @override
  List<Object> get props => [uid];
}
