import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import '../services/database_service.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TmdbService _tmdbService = TmdbService();
  final DatabaseService _dbService = DatabaseService();
  List<Movie> _results = [];
  bool _isLoading = false;
  String _error = '';

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) return;
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final results = await _tmdbService.searchMovies(query);
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load results. Check your connection.';
        _isLoading = false;
      });
    }
  }

  Future<void> _addToWatchlist(Movie movie) async {
    final already = await _dbService.isInWatchlist(movie.tmdbId);
    if (already) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Already in your watchlist!')),
      );
      return;
    }
    await _dbService.insertMovie(movie);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${movie.title} added to watchlist!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5BB8A0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5BB8A0),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 36),
            const SizedBox(width: 8),
            const Text(
              'Search',
              style: TextStyle(
                color: Color(0xFF2E7D6B),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: 'Search for a movie...',
                  hintStyle: const TextStyle(color: Colors.black38),
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.black38),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _results = []);
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onSubmitted: _searchMovies,
              ),
            ),
          ),

          if (_isLoading)
            const CircularProgressIndicator(color: Color(0xFF2E7D6B)),

          if (_error.isNotEmpty)
            Text(_error, style: const TextStyle(color: Colors.red)),

          // Results
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final movie = _results[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(movie: movie),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3D8B7A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // Poster
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: Image.network(
                            movie.posterPath,
                            width: 80,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 80,
                              height: 100,
                              color: const Color(0xFF2E7D6B),
                              child: const Icon(Icons.movie,
                                  color: Colors.white54),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Title : ${movie.title}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                movie.releaseDate.isNotEmpty
                                    ? movie.releaseDate.substring(0, 4)
                                    : 'Unknown',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${(movie.tmdbRating / 2).toStringAsFixed(1)}/5',
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Add button
                        IconButton(
                          icon: const Icon(Icons.bookmark_add,
                              color: Colors.white),
                          onPressed: () => _addToWatchlist(movie),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
