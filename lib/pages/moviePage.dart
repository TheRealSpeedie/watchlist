import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/genre.dart';
import '../models/movie.dart';
import '../services/sharedPreferences.dart';
import '../utility.dart';
import 'addPage.dart';
import 'archivPage.dart';
import 'filterPage.dart';

class MoviePage extends StatefulWidget {
  String title;
  MoviePage({super.key, required this.title});
  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late List<Movie> movies;
  List<Movie> filteredMovies = [];
  List<Genre> selectedGenres = [];

  int _selectedIndex = 0;

  Future<void> loadData() async {
    movies = await getAllItems();
    applyFilters();
  }

  void applyFilters() {
    filteredMovies = applyFilter(movies, selectedGenres, _selectedIndex);
    setState(() {});
  }

  void _openFilterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage(
          selectedGenres: selectedGenres,
          onGenresSelected: (genres) {
            setState(() {
              selectedGenres = genres;
              applyFilters();
            });
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Add movie navigation
  void addMovie() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMovieScreen(onMovieAdded: loadData),
      ),
    );
  }

  // Archiv navigation
  void archiv() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArchivScreen(),
      ),
    );
  }

  Future<void> openRandomDialog(BuildContext context) async {
    var okButton = TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        onPressed: () {Navigator.of(context).pop();},
        child: Text("OK"));
    if (filteredMovies.isEmpty) {
      OpenDialog(context, "Fehler", "Keine Filme vorhanden",[okButton]);
      return;
    }
    Movie movie = await getRandom(filteredMovies);
    String content =
        'Name: ${movie.name}\n Genre: ${movie.genre.toString().split('.').last}';
    List<Widget> button = [

    ];
    OpenDialog(context, movie.name, content, [okButton]);
  }

  void WatchedDialog(int index, context) {
    Movie movie = filteredMovies[index];
    String content = 'Hast du den Film gesehen?';
    List<Widget> buttons = [
      TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: () async {await changeWatchState(true, index);Navigator.of(context).pop();},
          child: Text("Ja")),
      TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: () {Navigator.of(context).pop();},
          child: Text("Nein"))
    ];
    OpenDialog(context, movie.name, content, buttons);
  }

  // Handle watch state change and remove item from the list
  Future<void> changeWatchState(bool value, int index) async {
    await editWatched(filteredMovies[index], value);
    loadData();
  }

  // Change the selected page for the Bottom Navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  bool get isFilterActive => selectedGenres.isNotEmpty;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          // Filter Button
          IconButton(
            icon: Icon(isFilterActive ? Icons.filter_list : Icons.filter_list_off),
            onPressed: _openFilterPage,
          ),
          IconButton(
            icon: Icon(Icons.shuffle),
            onPressed: () => openRandomDialog(context),
          ),
        ],
      ),
      body: Center(
        child: filteredMovies.isEmpty
            ? Text('Keine Filme mit diesen Kriterien')
            : ListView.builder(
          itemCount: filteredMovies.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(filteredMovies[index].name),
              subtitle: Text(
                  'Genre: ${filteredMovies[index].genre.toString().split('.').last}'),
              onTap: () {
                WatchedDialog(index, context); // Show the popup with movie details
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addMovie,
        tooltip: 'Film hinzufügen',
        child: const Icon(Icons.add_box_outlined),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ArchivScreen()),
            );
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: MainTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            label: ArchivTitle,
          ),
        ],
      ),
    );
  }
}