import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/genre.dart';
import '../models/movie.dart';
import '../services/sharedPreferences.dart';
import '../utility.dart';
import 'addPage.dart';
import 'filterPage.dart';

class MoviePage extends StatefulWidget {
  String title;
  int selectedIndex;
  bool isMainPage;
  MoviePage({super.key, required this.title, required this.selectedIndex})
      : isMainPage = selectedIndex == 0;
  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late List<Movie> movies;
  List<Movie> filteredMovies = [];
  List<Genre> selectedGenres = [];
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    loadData();
  }

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


  void addMovie() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMovieScreen(onMovieAdded: loadData),
      ),
    );
  }

  void archiv() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoviePage(title: ArchivTitle, selectedIndex: 1),
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
    String content = widget.isMainPage
        ? 'Hast du den Film gesehen?'
        : 'Möchtest du den Film nochmal anschauen?';
    List<Widget> buttons = [
      TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          onPressed: () async {await changeWatchState(widget.isMainPage, index);Navigator.of(context).pop();},
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

  Future<void> changeWatchState(bool value, int index) async {
    await editWatched(filteredMovies[index], value);
    loadData();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> TopActions(){
    List<Widget> widgets = [];
    widgets.add(IconButton(
      icon: Icon(isFilterActive ? Icons.filter_list : Icons.filter_list_off),
      onPressed: _openFilterPage,
    ),);
    if(widget.isMainPage){
      widgets.add(IconButton(
        icon: Icon(Icons.shuffle),
        onPressed: () => openRandomDialog(context),
      ));
    }
    return widgets;
  }
  FloatingActionButton? addButton(){
    if(widget.isMainPage){
      return FloatingActionButton(
        onPressed: addMovie,
        tooltip: 'Film hinzufügen',
        child: const Icon(Icons.add_box_outlined),
      );
    }
    return null;
  }
  bool get isFilterActive => selectedGenres.isNotEmpty;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: TopActions()
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
      floatingActionButton: addButton(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MoviePage(title: MainTitle, selectedIndex: 0)),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MoviePage(title: ArchivTitle, selectedIndex: 1)),
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