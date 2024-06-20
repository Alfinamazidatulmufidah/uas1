class Movie {
  final String title;
  final String posterPath;
  final String overview;
  final int id;
  final String ageRating;

  Movie({
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.id,
    required this.ageRating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      posterPath: 'https://image.tmdb.org/t/p/w500' + json['poster_path'],
      overview: json['overview'],
      id: json['id'],
      ageRating: json['adult'] ? '18+' : 'PG', // Atur nilai ageRating sesuai data JSON
    );
  }
}
