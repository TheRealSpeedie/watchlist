import 'package:flutter/material.dart';
import 'package:watchlist/utility/utility.dart';

import '../models/genre.dart';
import '../models/page.dart';
import '../pages/addPage.dart';
import '../pages/filterPage.dart';
import '../pages/mediaPage.dart';

class PageHandler{
  final VoidCallback loadDataCallback;
  final VoidCallback applyFilterCallback;

  PageHandler(this.loadDataCallback, this.applyFilterCallback);

  void openAddMediaPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMediaScreen(onMediaAdded: loadDataCallback),
      ),
    );
  }

  void openArchivPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MediaPage(title: ArchivTitle, selectedIndex: 1, onPage: OnPage.ARCHIV),
      ),
    );
  }

  List<Genre> openFilterPage(BuildContext context, List<Genre> selectedGenres) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterPage(
          selectedGenres: selectedGenres,
          onGenresSelected: (genres) {
              selectedGenres = genres;
              applyFilterCallback();
          },
        ),
      ),
    );
    return selectedGenres;
  }
}
