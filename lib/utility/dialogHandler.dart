import 'package:flutter/material.dart';
import 'package:watchlist/models/status.dart';
import 'package:watchlist/utility/pageHandler.dart';

import '../models/media.dart';
import '../services/sharedPreferences.dart';
import 'components.dart';

Future<void> openRandomDialog(BuildContext context, List<Media> filteredMedias) async {
  var okButton = TextButton(
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text("OK"));
  if (filteredMedias.isEmpty) {
    OpenDialog(context, "Fehler", Text("Kein Medium vorhanden"), [okButton]);
    return;
  }
  Media media = await getRandom(filteredMedias);
  String content = 'Name: ${media.name}\n Genre: ${media.genre.getCapital()}';
  OpenDialog(context, media.name, Text(content), [okButton]);
}

void ReWatchDialog( BuildContext context, Media media, PageHandler pageHandler){
  String content = 'Möchtest du ${media.name} nochmal anschauen?';
  var buttons = WatchStateContentButtons(context, media, Status.NOTWATCHED, pageHandler);
  OpenDialog(context, media.name, Text(content), buttons);
}
void StartWatchingDialog(BuildContext context , Media media, PageHandler pageHandler){
  String content = 'Möchtest du ${media.name} anfangen zu schauen?';
  var buttons = WatchStateContentButtons(context, media, Status.WATCHING, pageHandler);
  OpenDialog(context, media.name, Text(content), buttons);
}
void WatchedDialog(BuildContext context, Media media, PageHandler pageHandler) {
  String content =  'Hast du ${media.name} gesehen?';
  var buttons = WatchStateContentButtons(context, media, Status.WATCHED, pageHandler);
  OpenDialog(context, media.name, Text(content), buttons);
}

void OpenDialog(BuildContext context, String title, Widget content, List<Widget> theActions) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: theActions,
      );
    },
  );
}