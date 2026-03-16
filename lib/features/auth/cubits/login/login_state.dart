import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_app/features/auth/user_dm.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {final User? user;

  LoginSuccess({required this.user});}

class LoginError extends LoginState {
  final String message;

  LoginError(this.message);
}