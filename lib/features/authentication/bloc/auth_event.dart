part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignUpEvent(this.name, this.email, this.password);
  @override
  List<Object> get props => [name, email, password];
}

class LogInEvent extends AuthEvent {
  final String email;
  final String password;

  const LogInEvent(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

class LogOutEvent extends AuthEvent {}
