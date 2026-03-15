import 'package:dio/dio.dart';
import '../../movie_details/models/movie_details_model.dart';
import '../models/movie_model.dart';

class MovieApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://yts.lt/api/v2/'));

  Future<List<MovieModel>> getMovies({int limit = 20, String? genre}) async {
    try {
      final response = await _dio.get(
        'list_movies.json',
        queryParameters: {'limit': limit, 'genre': ?genre},
      );

      if (response.statusCode == 200 && response.data['status'] == 'ok') {
        final List moviesJson = response.data['data']['movies'] ?? [];
        return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load movies from API.');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    try {
      final response = await _dio.get(
        'movie_details.json',
        queryParameters: {
          'movie_id': movieId,
          'with_images': true,
          'with_cast': true,
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'ok') {
        return MovieDetailsModel.fromJson(response.data['data']['movie']);
      } else {
        throw Exception('Failed to load movie details.');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<MovieModel>> getMovieSuggestions(int movieId) async {
    try {
      final response = await _dio.get(
        'movie_suggestions.json',
        queryParameters: {'movie_id': movieId},
      );

      if (response.statusCode == 200 && response.data['status'] == 'ok') {
        final List moviesJson = response.data['data']['movies'] ?? [];
        return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load suggestions.');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final response = await _dio.get(
        'list_movies.json',
        queryParameters: {'query_term': query},
      );

      if (response.statusCode == 200 && response.data['status'] == 'ok') {
        final List moviesJson = response.data['data']['movies'] ?? [];
        return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search movies.');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
