class Movie {
  final int? id;
  final int tmdbId;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double tmdbRating;
  double? userRating;
  String? userReview;
  bool isWatched;

  Movie({
    this.id,
    required this.tmdbId,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.tmdbRating,
    this.userRating,
    this.userReview,
    this.isWatched = false,
  });

  // Convert Movie to a Map for storing in database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tmdbId': tmdbId,
      'title': title,
      'overview': overview,
      'posterPath': posterPath,
      'releaseDate': releaseDate,
      'tmdbRating': tmdbRating,
      'userRating': userRating,
      'userReview': userReview,
      'isWatched': isWatched ? 1 : 0,
    };
  }

  // Convert a Map from database back to a Movie
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      tmdbId: map['tmdbId'],
      title: map['title'],
      overview: map['overview'],
      posterPath: map['posterPath'],
      releaseDate: map['releaseDate'],
      tmdbRating: map['tmdbRating'],
      userRating: map['userRating'],
      userReview: map['userReview'],
      isWatched: map['isWatched'] == 1,
    );
  }
}
