import 'package:flutter/material.dart';
import 'package:watchlist/models/movie.dart';

import '../models/genre.dart';
import '../services/sharedPreferences.dart';

class AddMovieScreen extends StatefulWidget {
  final VoidCallback onMovieAdded; // Callback, um die Liste zu aktualisieren

  AddMovieScreen({required this.onMovieAdded});

  @override
  _AddMovieScreen createState() => _AddMovieScreen();
}

class _AddMovieScreen extends State<AddMovieScreen> {
  final TextEditingController _movieNameController = TextEditingController();
  Genre? _selectedGenre = Genre.ACTION;
  final _formKey = GlobalKey<FormState>();

  void _saveMovie() async {
    var movieWithHighestID = await getMovieWithHighestId();
    var id = movieWithHighestID?.id ?? 0;
    Movie movie = Movie(id: id+1,name: _movieNameController.text, genre: _selectedGenre!, watched: false);
    await saveMovie(movie);
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Film "${_movieNameController.text}" mit Genre "${_selectedGenre?.toString().split('.').last}" gespeichert!'),
      ));
      widget.onMovieAdded();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text("Film Hinzufügen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _movieNameController,
                decoration: InputDecoration(
                  labelText: 'Name des Films',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie den Namen des Films ein';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Genre>(
                value: _selectedGenre,
                onChanged: (Genre? newValue) {
                  setState(() {
                    _selectedGenre = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Genre auswählen',
                  border: OutlineInputBorder(),
                ),
                items: Genre.values.map<DropdownMenuItem<Genre>>((Genre value) {
                  return DropdownMenuItem<Genre>(
                    value: value,
                    child: Text(value.toString().split('.').last),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveMovie,
                child: Text('Speichern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
