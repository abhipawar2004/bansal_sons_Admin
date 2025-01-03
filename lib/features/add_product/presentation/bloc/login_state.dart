part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Login login;

  LoginSuccess(this.login);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}
