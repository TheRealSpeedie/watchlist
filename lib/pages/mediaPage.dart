import 'package:flutter/material.dart';
import 'package:watchlist/pages/readInPage.dart';
import 'package:watchlist/utility/pageHandler.dart';

import '../models/genre.dart';
import '../models/media.dart';
import '../models/page.dart';
import '../services/filePicker.dart';
import '../services/sharedPreferences.dart';
import '../utility/components.dart';
import '../utility/dialogHandler.dart';
import '../utility/utility.dart';

class MediaPage extends StatefulWidget {
  String title;
  int selectedIndex;
  OnPage onPage;
  MediaPage({super.key, required this.title, required this.selectedIndex, required this.onPage});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  late List<Media> Medias;
  late PageHandler _pageHandler;
  late int _selectedIndex;
  List<Media> filteredMedias = [];
  List<Genre> selectedGenres = [];
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    _pageHandler = PageHandler(loadData, applyFilters);
    loadData();
  }

  Future<void> loadData() async {
    Medias = await getAllItems();
    applyFilters();
  }

  void applyFilters() {
    filteredMedias = applyFilter(Medias, selectedGenres, widget.onPage);
    setState(() {});
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> readInFile() async {
    List<Media> medias = await getMediasFromFile();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReadInPage(medias: medias,),
      ),
    );
  }

  List<Widget> TopActions() {
    List<Widget> widgets = [];
    widgets.add(
      IconButton(
        icon: Icon(isFilterActive ? Icons.filter_list : Icons.filter_list_off),
        onPressed: () => setState(() {
          selectedGenres = _pageHandler.openFilterPage(context, selectedGenres);
        }),
      ),
    );
    if (widget.onPage == OnPage.MAIN) {
      widgets.add(IconButton(
        icon: Icon(Icons.shuffle),
        onPressed: () => openRandomDialog(context, filteredMedias),
      ));
      widgets.add(IconButton(
        icon: Icon(Icons.read_more),
        onPressed: () => readInFile(),
      ));
    }
    return widgets;
  }

  bool get isFilterActive => selectedGenres.isNotEmpty;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: TopActions()),
      body: Center(
        child: filteredMedias.isEmpty
            ? Text('Keine Filme oder Serien')
            : ListView.builder(
                itemCount: filteredMedias.length,
                itemBuilder: (context, index) {
                  if(widget.onPage == OnPage.MAIN){
                    return MainListTile(filteredMedias[index], context, _pageHandler);
                  }else if(widget.onPage == OnPage.ARCHIV){
                    return ArchivListTile(filteredMedias[index], context, _pageHandler);
                  }else{
                    return watchingListTile(filteredMedias[index], context, _pageHandler);
                  }
                },
              ),
      ),
      floatingActionButton: addButton(widget.onPage,_pageHandler,context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MediaPage(title: MainTitle, selectedIndex: 0, onPage: OnPage.MAIN,)),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MediaPage(title: WatchingTitle, selectedIndex: 1, onPage: OnPage.INPROGRESS)),
            );
          }else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MediaPage(title: ArchivTitle, selectedIndex: 2, onPage: OnPage.ARCHIV)),
            );
          }
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video),
            label: MainTitle,
          ),BottomNavigationBarItem(
            icon: Icon(Icons.watch_later_outlined),
            label: WatchingTitle,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: ArchivTitle,
          ),
        ],
      ),
    );
  }
}
