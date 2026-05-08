import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/database_service.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;
  final bool fromWatchlist;

  const DetailScreen({
    super.key,
    required this.movie,
    this.fromWatchlist = false,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final DatabaseService _dbService = DatabaseService();
  final TextEditingController _reviewController = TextEditingController();
  double _userRating = 0;
  bool _isWatched = false;
  bool _inWatchlist = false;

  @override
  void initState() {
    super.initState();
    _userRating = widget.movie.userRating ?? 0;
    _isWatched = widget.movie.isWatched;
    _reviewController.text = widget.movie.userReview ?? '';
    _checkWatchlist();
  }

  Future<void> _checkWatchlist() async {
    final inList = await _dbService.isInWatchlist(widget.movie.tmdbId);
    setState(() => _inWatchlist = inList);
  }

  Future<void> _addToWatchlist() async {
    await _dbService.insertMovie(widget.movie);
    setState(() => _inWatchlist = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.movie.title} added to watchlist!')),
    );
  }

  Future<void> _saveChanges() async {
    widget.movie.userRating = _userRating;
    widget.movie.userReview = _reviewController.text;
    widget.movie.isWatched = _isWatched;
    await _dbService.updateMovie(widget.movie);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved!')),
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = (index + 1).toDouble();
        return GestureDetector(
          onTap: _inWatchlist
              ? () => setState(() => _userRating = starValue)
              : null,
          child: Icon(
            _userRating >= starValue ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 40,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5BB8A0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5BB8A0),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF2E7D6B)),
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 36),
            const SizedBox(width: 8),
            const Text(
              'Movie Details',
              style: TextStyle(
                color: Color(0xFF2E7D6B),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        actions: [
          if (!_inWatchlist)
            IconButton(
              icon: const Icon(Icons.bookmark_add, color: Color(0xFF2E7D6B)),
              onPressed: _addToWatchlist,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Large poster banner
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.movie.posterPath,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: const Color(0xFF3D8B7A),
                  child:
                      const Icon(Icons.movie, color: Colors.white54, size: 80),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              widget.movie.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Year
            Text(
              widget.movie.releaseDate.isNotEmpty
                  ? '${widget.movie.releaseDate.substring(0, 4)} : ${widget.movie.tmdbRating.toStringAsFixed(1)} TMDB'
                  : 'Unknown year',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),

            const SizedBox(height: 16),

            // Star rating
            _buildStarRating(),

            const SizedBox(height: 8),

            Text(
              'Your rating : ${_userRating.toStringAsFixed(0)}/5 stars',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Overview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF3D8B7A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.movie.overview.isNotEmpty
                    ? widget.movie.overview
                    : 'No overview available.',
                style: const TextStyle(color: Colors.white70, height: 1.5),
              ),
            ),

            const SizedBox(height: 16),

            // Review box
            if (_inWatchlist) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _reviewController,
                  style: const TextStyle(color: Colors.black87),
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Write your review here...',
                    hintStyle: TextStyle(color: Colors.black38),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Watched toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Switch(
                    value: _isWatched,
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF2E7D6B),
                    onChanged: (val) => setState(() => _isWatched = val),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isWatched ? 'ON - Mark as watched' : 'Mark as watched',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D6B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
