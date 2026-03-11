import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/auth_api_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthApiService authApiService;

  AuthBloc({required this.authApiService}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  // Future<void> _onLoginRequested(
  //     LoginRequested event,
  //     Emitter<AuthState> emit,
  //     ) async {
  //   emit(AuthLoading());
  //   try {
  //     // Calls the POST /auth/login API
  //     final token = await authApiService.login(event.request);
  //
  //
  //     emit(const AuthSuccess('Login Successful!'));
  //   } catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }
  //
  // Future<void> _onRegisterRequested(
  //     RegisterRequested event,
  //     Emitter<AuthState> emit,
  //     ) async {
  //   emit(AuthLoading());
  //   try {
  //     // Calls the POST /auth/register API
  //     final userData = await authApiService.register(event.request);
  //
  //     emit(const AuthSuccess('Registration Successful! You can now log in.'));
  //   } catch (e) {
  //     emit(AuthFailure(e.toString()));
  //   }
  // }

  Future<void> _onRegisterRequested(
      RegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));

      emit(const AuthSuccess('Test Registration Successful!'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(const AuthSuccess('Test Login Successful!'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}