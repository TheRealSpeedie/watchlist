import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watchlist/models/MediaCategory.dart';
import 'package:watchlist/utility/pageHandler.dart';
import 'package:watchlist/utility/serieHandler.dart';
import 'package:watchlist/utility/utility.dart';

import '../models/media.dart';
import '../models/page.dart';
import '../models/status.dart';
import 'dialogHandler.dart';

List<Widget> WatchStateContentButtons(
    BuildContext context, Media media, Status status, PageHandler pageHandler) {
  return [
    TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        onPressed: () async {
          await changeWatchState(status,media, pageHandler);
          Navigator.of(context).pop();
        },
        child: Text("Ja")),
    TextButton(
        style: TextButton.styleFrom(
          textStyle: Theme.of(context).textTheme.labelLarge,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Nein"))
  ];
}

FloatingActionButton? addButton(OnPage onPage, PageHandler pageHandler, BuildContext context) {
  if (onPage == OnPage.MAIN) {
    return FloatingActionButton(
      onPressed: () => pageHandler.openAddMediaPage(context),
      tooltip: 'Film hinzufügen',
      child: const Icon(Icons.add_box_outlined),
    );
  }
  return null;
}

ListTile MainListTile(Media media, BuildContext context, PageHandler pageHandler) {
  if(media.category == MediaCategory.MOVIE) {
    return ListTile(
      title: Text(media.name),
      subtitle: Text('Genre: ${media.genre.getCapital()}'),
      onTap: () {
        WatchedDialog(
            context, media, pageHandler); // Show the popup with Media details
      },
    );
  }else{
    return ListTile(
      title: Text(media.name),
      subtitle: Text('Genre: ${media.genre.getCapital()}'),
      onTap: () {
        StartWatchingDialog(
            context, media, pageHandler); // Show the popup with Media details
      },
    );
  }
}

ListTile ArchivListTile(Media media, BuildContext context, PageHandler pageHandler) {
  return ListTile(
      title: Text(media.name),
      subtitle: Text('Genre: ${media.genre.getCapital()}'),
      trailing: Text(
          'Gesehen am: ${media.ConvertStartWatchingDate()}'),
      onTap: () {
        ReWatchDialog(context, media,pageHandler); // Show the popup with Media details
      });
}

ExpansionTile watchingListTile(Media media, BuildContext context, PageHandler pagehandler) {
  return ExpansionTile(
      title: Text(media.name),
      subtitle: Text('Genre: ${media.genre.getCapital()}'),
      trailing: Text(
        'S${media.serieAddon.currentSeason} E${media.serieAddon.currentSequence} angefangen am ${media.serieAddon.ConvertStartWatchingDate()}',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.remove),
                    label: Text('Folge'),
                    onPressed: () => decreaseEpisode(media, context, pagehandler),
                  ),
                  Text(
                    'Staffel ${media.serieAddon.currentSeason} - Folge ${media.serieAddon.currentSequence}',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Folge'),
                    onPressed: () => increaseEpisode(media, context, pagehandler),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.remove),
                    label: Text('Staffel'),
                    onPressed: () => decreaseSeason(media, context,pagehandler),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Staffel'),
                    onPressed: () => increaseSeason(media, context, pagehandler),
                  ),
                ],
              ),
            ],
          ),
        )
      ]);
}
