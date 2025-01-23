import 'genre.dart';

class Movie {
  int id;
  String name;
  Genre genre;
  bool watched;
  DateTime? watchedDate;  // Datum hinzufügen

  Movie({required this.id,required this.name, required this.genre, required this.watched, this.watchedDate});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      name: json['movieName'],
      genre: Genre.values.firstWhere((e) => e.toString() == 'Genre.' + json['genre']),
      watched: json['watched'],
      watchedDate: json['watchedDate'] != null ? DateTime.parse(json['watchedDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'movieName': name,
      'genre': genre.toString().split('.').last,
      'watched': watched,
      'watchedDate': watchedDate?.toIso8601String(),  // Datum als String speichern
    };
  }
}
