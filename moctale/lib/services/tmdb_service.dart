import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class TmdbService {
  static const String _apiKey = 'dc95b05087c011020e5c1af208348a90';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // Search movies by title
  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.parse(
        '$_baseUrl/search/movie?api_key=$_apiKey&query=${Uri.encodeComponent(query)}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;

      return results
          .where((movie) => movie['poster_path'] != null)
          .map((movie) => Movie(
                tmdbId: movie['id'],
                title: movie['title'] ?? 'Unknown',
                overview: movie['overview'] ?? '',
                posterPath: '$_imageBaseUrl${movie['poster_path']}',
                releaseDate: movie['release_date'] ?? '',
                tmdbRating: (movie['vote_average'] ?? 0).toDouble(),
              ))
          .toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
