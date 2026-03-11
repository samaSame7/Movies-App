import 'package:dio/dio.dart';
import '../../home/models/movie_model.dart';

class ProfileApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://route-movie-apis.vercel.app/',
  ));

  Future<List<MovieModel>> getWatchlist(String token) async {
    try {
      final response = await _dio.get(
        'watchlist',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        return data.map((json) => MovieModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}