import 'package:dio/dio.dart';
import '../models/auth_models.dart';

class AuthApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://route-movie-apis.vercel.app/',
  ));

  Future<String> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        'auth/login',
        data: request.toJson(),
      );
      return response.data['data'];
    } on DioException catch (e) {
      print('=== LOGIN API ERROR ===');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      print('=======================');

      if (e.response != null && e.response?.data != null) {
        final serverMessage = e.response?.data['message'] ?? e.response?.data.toString();
        throw Exception(serverMessage);
      }
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      print('=== LOGIN GENERAL ERROR ===\n$e\n===========================');
      throw Exception('Failed to login: $e');
    }
  }

  Future<Map<String, dynamic>> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        'auth/register',
        data: request.toJson(),
      );
      return response.data['data'];
    } on DioException catch (e) {
      print('=== REGISTER API ERROR ===');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      print('==========================');

      if (e.response != null && e.response?.data != null) {
        final serverMessage = e.response?.data['message'] ?? e.response?.data.toString();
        throw Exception(serverMessage);
      }
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      print('=== REGISTER GENERAL ERROR ===\n$e\n==============================');
      throw Exception('Failed to register: $e');
    }
  }
}