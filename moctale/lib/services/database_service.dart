import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie.dart';

class DatabaseService {
  // Singleton pattern - only one instance of database exists
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  // Get database, createS it if it doesn't exist
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'moctale.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create the movies table
        await db.execute('''
          CREATE TABLE movies (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tmdbId INTEGER NOT NULL,
            title TEXT NOT NULL,
            overview TEXT,
            posterPath TEXT,
            releaseDate TEXT,
            tmdbRating REAL,
            userRating REAL,
            userReview TEXT,
            isWatched INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  // Add a movie to watchlist
  Future<int> insertMovie(Movie movie) async {
    final db = await database;
    return await db.insert('movies', movie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get all movies in watchlist
  Future<List<Movie>> getMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('movies');
    return List.generate(maps.length, (i) => Movie.fromMap(maps[i]));
  }

  // Update a movie (rating, review, watched status)
  Future<void> updateMovie(Movie movie) async {
    final db = await database;
    await db.update('movies', movie.toMap(),
        where: 'id = ?', whereArgs: [movie.id]);
  }

  // Delete a movie from watchlist
  Future<void> deleteMovie(int id) async {
    final db = await database;
    await db.delete('movies', where: 'id = ?', whereArgs: [id]);
  }

  // Check if a movie is already in watchlist
  Future<bool> isInWatchlist(int tmdbId) async {
    final db = await database;
    final result =
        await db.query('movies', where: 'tmdbId = ?', whereArgs: [tmdbId]);
    return result.isNotEmpty;
  }
}
