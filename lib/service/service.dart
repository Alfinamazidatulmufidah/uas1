import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String apiKey = 'da2f154408ef7dab162b747e39577769';
  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<dynamic>> getNowPlayingMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load movies');
    }
  }

  searchMovies(String text) {}
}

