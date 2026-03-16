import 'package:firebase_auth/firebase_auth.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final User user;

  RegisterSuccess(this.user);
}

class RegisterError extends RegisterState {
  final String message;

  RegisterError(this.message);
}
