import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watchlist/models/movie.dart';
import 'package:watchlist/models/genre.dart';

Future<List<Movie>> _getMovies() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? jsonMovies = prefs.getString('movies');
  if (jsonMovies != null) {
    List<dynamic> decodedMovies = jsonDecode(jsonMovies);
    return decodedMovies.map((movie) => Movie.fromJson(movie)).toList();
  }
  return [];
}

Future<void> _saveMovies(List<Movie> movies) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<Map<String, dynamic>> moviesJson = movies.map((movie) => movie.toJson()).toList();
  await prefs.setString('movies', jsonEncode(moviesJson));
}

Future<void> saveMovie(Movie movie) async {
  List<Movie> movies = await getAllItems();
  movies.add(movie);
  await _saveMovies(movies);
}

Future<void> editWatched(Movie movie, bool watchedStatus) async {
  List<Movie> movies = await getAllItems();
  int index = movies.indexWhere((m) => m.id == movie.id);

  if (index != -1) {
    movies[index].watched = watchedStatus;
    if (watchedStatus) {
      movies[index].watchedDate = DateTime.now();
    } else {
      movies[index].watchedDate = null;
    }
    await _saveMovies(movies);
  }
}

Future<Movie?> getMovieWithHighestId() async {
  List<Movie> movieList = await getAllItems();
  Movie? movieWithHighestId = movieList.firstOrNull;
  int maxId = -1;

  for (var movie in movieList) {
    int movieId = movie.id;
    if (movieId > maxId) {
      maxId = movieId;
      movieWithHighestId = movie;
    }
  }
  return movieWithHighestId;
}

Future<List<Movie>> getAllItems() async {
  return await _getMovies();
}

Future<List<Movie>> getAllWatched() async {
  List<Movie> movies = await _getMovies();
  return movies.where((movie) => movie.watched).toList();
}

Future<List<Movie>> getAllNotWatched() async {
  List<Movie> movies = await _getMovies();
  return movies.where((movie) => !movie.watched).toList();
}

Future<List<Movie>> getAllByGenre(Genre genre) async {
  List<Movie> movies = await _getMovies();
  return movies.where((movie) => movie.genre == genre).toList();
}

Future<Movie> getRandom(List<Movie> movies) async {
  if (movies.isNotEmpty) {
    int randomIndex = Random().nextInt(movies.length);
    return movies[randomIndex];
  } else {
    return  Movie(id: 1, name: "", genre: Genre.ACTION, watched: false);
  }
}
