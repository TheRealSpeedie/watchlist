import 'package:flutter/material.dart';
import 'package:watchlist/models/status.dart';
import 'package:watchlist/utility/pageHandler.dart';
import 'package:watchlist/utility/utility.dart';

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
void WatchedSerieDialog(BuildContext context, Media media, PageHandler pageHandler) {
String content =  'Ich bestätige das ich das Ende von ${media.name} erreicht habe';
var buttons = [
  TextButton(
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      onPressed: () async {
        await changeWatchState(Status.WATCHED,media, pageHandler);
        Navigator.of(context).pop();
      },
      child: Text("Ja")),
  TextButton(
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      onPressed: () {
        Navigator.of(context).pop();
        ChangeEndOfSerieDialog(context, media,pageHandler);
      },
      child: Text("Nein"))
];
OpenDialog(context, "Bitte bestätigen", Text(content), buttons);
}
void ChangeEndOfSerieDialog(BuildContext context, Media media, PageHandler pageHandler) {
  Widget widget = Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          decoration: InputDecoration(labelText: 'Letzte Folge'),
          keyboardType: TextInputType.number,
          controller: TextEditingController(
            text: media.serieAddon.finalSequence.toString(),
          ),
          onChanged: (value) {
            media.serieAddon.finalSequence =
                int.tryParse(value) ?? 0;
          },
        ),
      ),
      SizedBox(height: 8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          decoration: InputDecoration(labelText: 'Letzte Staffel'),
          keyboardType: TextInputType.number,
          controller: TextEditingController(
            text: media.serieAddon.finalSeason.toString(),
          ),
          onChanged: (value) {
            media.serieAddon.finalSeason =
                int.tryParse(value) ?? 0;
          },
        ),
      ),
    ],
  );

  List<Widget> buttons = [
    TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        onPressed: () async {
          await changeFinalSeasonAndEpisode(media, pageHandler);
          Navigator.of(context).pop();
        },
        child: Text("Speichern"))
  ];

  OpenDialog(context, "Ende der Serie bearbeiten", widget, buttons);
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