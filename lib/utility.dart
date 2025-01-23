import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/genre.dart';
import 'models/movie.dart';

final String MainTitle = "Deine Watchlist";
final String ArchivTitle = "Filmarchiv";

List<Movie> applyFilter(List<Movie> movies, List<Genre> selectedGenres, int index) {
  var filteredMovies = movies.where((movie) {
    final matchesGenre = selectedGenres.isEmpty || selectedGenres.contains(movie.genre);
    return matchesGenre;
  }).toList();
  if (index == 1) {
    filteredMovies = filteredMovies.where((movie) => movie.watched).toList();
  }else{
    filteredMovies = filteredMovies.where((movie) => !movie.watched).toList();
  }
  return filteredMovies;
}

void detailPopUp(int index, BuildContext context, List<Movie> filteredMovies) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(filteredMovies[index].name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Genre: ${filteredMovies[index].genre.toString().split('.').last}'),
            Text('Watched: ${filteredMovies[index].watched ? "Yes" : "No"}'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void OpenDialog(BuildContext context, String title, String content, List<Widget> theActions) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: theActions,
      );
    },
  );
}




