import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/database_service.dart';
import 'detail_screen.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<Movie> _movies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() => _isLoading = true);
    final movies = await _dbService.getMovies();
    setState(() {
      _movies = movies;
      _isLoading = false;
    });
  }

  Future<void> _deleteMovie(Movie movie) async {
    await _dbService.deleteMovie(movie.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${movie.title} removed from watchlist')),
    );
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5BB8A0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D8B7A),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 36),
            const SizedBox(width: 8),
            const Text(
              'My Watchlist',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white))
          : _movies.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.movie_filter,
                          color: Colors.white54, size: 80),
                      const SizedBox(height: 16),
                      const Text(
                        'Your watchlist is empty!',
                        style:
                            TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Search for movies and add them.',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadMovies,
                  color: const Color(0xFF3D8B7A),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _movies.length,
                    itemBuilder: (context, index) {
                      final movie = _movies[index];
                      return Dismissible(
                        key: Key(movie.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child:
                              const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _deleteMovie(movie),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3D8B7A),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                movie.posterPath,
                                width: 55,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.movie,
                                    color: Colors.white54),
                              ),
                            ),
                            title: Text(
                              'Title : ${movie.title}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.releaseDate.isNotEmpty
                                      ? movie.releaseDate.substring(0, 4)
                                      : 'Unknown year',
                                  style: const TextStyle(
                                      color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Text('Watched: ',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12)),
                                    Switch(
                                      value: movie.isWatched,
                                      activeColor: Colors.white,
                                      activeTrackColor:
                                          const Color(0xFF2E7D6B),
                                      onChanged: (val) async {
                                        movie.isWatched = val;
                                        await _dbService.updateMovie(movie);
                                        _loadMovies();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailScreen(
                                    movie: movie,
                                    fromWatchlist: true,
                                  ),
                                ),
                              );
                              _loadMovies();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}