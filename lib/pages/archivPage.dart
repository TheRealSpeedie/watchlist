import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../models/genre.dart';
import '../models/movie.dart';
import '../services/sharedPreferences.dart';
import '../utility.dart';
import 'addPage.dart';
import 'filterPage.dart';

class ArchivScreen extends StatefulWidget {
  @override
  _ArchivScreen createState() => _ArchivScreen();
}


class _ArchivScreen extends State<ArchivScreen> {
  late List<Movie> movies;
  List<Movie> filteredMovies = [];
  List<Genre> selectedGenres = [];

  int _selectedIndex = 1;

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

  // Archiv navigation
  void archiv() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArchivScreen(),
      ),
    );
  }

  void WatchedDialog(int index, context) {
    Movie movie = filteredMovies[index];
    String content = 'Möchtest du den Film nochmal anschauen?';
    List<Widget> buttons = [
      TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: () async {await changeWatchState(false, index);Navigator.of(context).pop();},
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
        title: Text(ArchivTitle),
        actions: [
          // Filter Button
          IconButton(
            icon: Icon(isFilterActive ? Icons.filter_list : Icons.filter_list_off),
            onPressed: _openFilterPage,
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
