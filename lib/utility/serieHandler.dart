import 'package:flutter/cupertino.dart';
import 'package:watchlist/utility/pageHandler.dart';

import '../models/media.dart';
import '../services/sharedPreferences.dart';
import 'dialogHandler.dart';

Future<void> increaseEpisode(Media media, BuildContext context, PageHandler pagehandler) async {
  media.serieAddon.currentSequence++;
  await ChangeStateOfEpisode(media,media.serieAddon.currentSequence);
  await CheckSerie(media, context);
  pagehandler.loadDataCallback();
}

Future<void> decreaseEpisode(Media media, BuildContext context, PageHandler pagehandler) async {
  if (media.serieAddon.currentSequence > 1) {
    media.serieAddon.currentSequence--;
  }
  await ChangeStateOfEpisode(media,media.serieAddon.currentSequence);
  await CheckSerie(media, context);
  pagehandler.loadDataCallback();
}

Future<void> increaseSeason(Media media, BuildContext context, PageHandler pagehandler) async {
  media.serieAddon.currentSeason++;
  media.serieAddon.currentSequence = 1;
  await ChangeStateOfSeason(media,media.serieAddon.currentSeason);
  await ChangeStateOfEpisode(media,media.serieAddon.currentSequence);
  await CheckSerie(media, context);
  pagehandler.loadDataCallback();
}

Future<void> decreaseSeason(Media media, BuildContext context, PageHandler pagehandler) async {
  if (media.serieAddon.currentSeason > 1) {
    media.serieAddon.currentSeason--;
  }
  await ChangeStateOfSeason(media, media.serieAddon.currentSeason);
  await CheckSerie(media, context);
  pagehandler.loadDataCallback();
}
Future<void> CheckSerie(Media media, BuildContext context) async {
  var finish = await isSerieFinish(media);
  if(finish){
    var title = "Ende der Serie";
    var content = Text("Bitte bestätige das du mit der Serie fertig bist");
    List<Widget> theActions = [];
    OpenDialog(context, title, content, theActions);
  }
}

