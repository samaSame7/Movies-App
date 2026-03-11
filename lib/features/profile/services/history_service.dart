import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/models/movie_model.dart';

class HistoryService {
  static const String _historyKey = 'movie_history';

  Future<void> saveToHistory(MovieModel movie) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyList = prefs.getStringList(_historyKey) ?? [];

    historyList.removeWhere((item) {
      final decoded = jsonDecode(item);
      return decoded['id'] == movie.id;
    });

    historyList.insert(0, jsonEncode({
      'id': movie.id,
      'title': movie.title,
      'rating': movie.rating,
      'medium_cover_image': movie.mediumCoverImage,
      'genres': movie.genres,
    }));

    if (historyList.length > 20) {
      historyList = historyList.sublist(0, 20);
    }

    await prefs.setStringList(_historyKey, historyList);
  }

  Future<List<MovieModel>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> historyList = prefs.getStringList(_historyKey) ?? [];

    return historyList.map((item) {
      return MovieModel.fromJson(jsonDecode(item));
    }).toList();
  }
}