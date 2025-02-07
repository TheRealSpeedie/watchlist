import 'package:flutter/material.dart';
import 'package:watchlist/models/page.dart';
import 'package:watchlist/models/status.dart';
import 'package:watchlist/utility/pageHandler.dart';
import '../models/genre.dart';
import '../models/media.dart';
import '../services/sharedPreferences.dart';

final String MainTitle = "Deine Watchlist";
final String ArchivTitle = "Archiv";
final String WatchingTitle = "In Progress";

List<Media> applyFilter(List<Media> Medias, List<Genre> selectedGenres, OnPage onpage) {
  var filteredMedias = Medias.where((Media) {
    final matchesGenre = selectedGenres.isEmpty || selectedGenres.contains(Media.genre);
    return matchesGenre;
  }).toList();
  if(onpage == OnPage.INPROGRESS){
    filteredMedias = filteredMedias.where((Media) => Media.watched == Status.WATCHING).toList();
  }
  else if (onpage == OnPage.ARCHIV) {
    filteredMedias = filteredMedias.where((Media) => Media.watched == Status.WATCHED).toList();
  }else{
    filteredMedias = filteredMedias.where((Media) => Media.watched == Status.NOTWATCHED).toList();
  }
  return filteredMedias;
}

Future<void> changeWatchState(Status status, Media media, PageHandler pageHandler) async {
  await editWatched(media, status);
  pageHandler.loadDataCallback();
}

Future<void> changeFinalSeasonAndEpisode(Media media, PageHandler pageHandler) async {
  await UpdateMedia(media);
  pageHandler.loadDataCallback();
}

void message(String text, BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}

(int, int) extractSeasonAndSequence(String input) {
  RegExp seasonRegExp = RegExp(r'St (\d+)');
  RegExp sequenceRegExp = RegExp(r'folge (\d+)');

  int? currentSeason;
  int? currentSequence;

  Match? seasonMatch = seasonRegExp.firstMatch(input);
  if (seasonMatch != null) {
    currentSeason = int.parse(seasonMatch.group(1)!);
  }

  Match? sequenceMatch = sequenceRegExp.firstMatch(input);
  if (sequenceMatch != null) {
    currentSequence = int.parse(sequenceMatch.group(1)!);
  }

  return (currentSeason ?? 0 , currentSequence ?? 0);
}






