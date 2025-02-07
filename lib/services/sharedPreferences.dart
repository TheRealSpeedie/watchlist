import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watchlist/models/media.dart';
import 'package:watchlist/models/genre.dart';
import 'package:watchlist/models/MediaCategory.dart';
import 'package:watchlist/models/serieAddon.dart';
import 'package:watchlist/models/status.dart';

Future<List<Media>> _getMedias() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.clear();
  String? jsonMedias = prefs.getString('media');
  if (jsonMedias != null) {
    List<dynamic> decodedMovies = jsonDecode(jsonMedias);
    return decodedMovies.map((media) => Media.fromJson(media)).toList();
  }
  return [];
}

Future<void> _saveMedias(List<Media> medias) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<Map<String, dynamic>> jsonMedias = medias.map((media) => media.toJson()).toList();
  await prefs.setString('media', jsonEncode(jsonMedias));
}

Future<void> saveMedia(Media media) async {
  List<Media> medias = await getAllItems();
  medias.add(media);
  await _saveMedias(medias);
}

Future<void> saveMedias(List<Media> medias) async {
  await _saveMedias(medias);
}

Future<void> UpdateMedia(Media media) async{
  List<Media> medias = await _getMedias();
  int index = medias.indexWhere((m) => m.id == media.id);
  medias.removeAt(index);
  medias.add(media);
  saveMedias(medias);
}

Future<void> editWatched(Media media, Status watchedStatus) async {
  List<Media> medias = await getAllItems();
  int index = medias.indexWhere((m) => m.id == media.id);

  if (index != -1) {
    medias[index].watched = watchedStatus;
    if (watchedStatus == Status.WATCHED) {
      medias[index].watchedDate = DateTime.now();
    } else {
      medias[index].watchedDate = null;
    }
    if(watchedStatus == Status.WATCHING){
      medias[index].serieAddon.startedWatching = DateTime.now();
      if(medias[index].serieAddon.currentSequence == 0){
        medias[index].serieAddon.currentSequence = 1;
      }
    }
    await _saveMedias(medias);
  }
}

Future<int> getMediaWithHighestID() async {
  List<Media> mediaList = await getAllItems();
  int maxId = 0;

  for (var media in mediaList) {
    int mediaId = media.id;
    if (mediaId > maxId) {
      maxId = mediaId;
    }
  }
  return maxId;
}

Future<List<Media>> getAllItems() async {
  return await _getMedias();
}
Future<List<Media>> getAllByGenre(Genre genre) async {
  List<Media> medias = await _getMedias();
  return medias.where((media) => media.genre == genre).toList();
}

Future<Media> getRandom(List<Media> medias) async {
  if (medias.isNotEmpty) {
    int randomIndex = Random().nextInt(medias.length);
    return medias[randomIndex];
  } else {
    var serienaddon = SerieAddon(startedWatching: DateTime.now(), currentSeason: 0, currentSequence: 0, finalSeason: 0, finalSequence: 0);
    return  Media(id: 1, name: "", genre: Genre.ACTION, watched: Status.NOTWATCHED, category: MediaCategory.MOVIE, serieAddon: serienaddon);
  }
}

Future<void> ChangeStateOfEpisode(Media media, int currentEpisode) async {
  List<Media> medias = await getAllItems();
  int index = medias.indexWhere((m) => m.id == media.id);

  if (index != -1) {
    medias[index].serieAddon.currentSequence = currentEpisode;

    await _saveMedias(medias);
  }
}
Future<void> ChangeStateOfSeason(Media media, int currentSeason) async {
  List<Media> medias = await getAllItems();
  int index = medias.indexWhere((m) => m.id == media.id);

  if (index != -1) {
    medias[index].serieAddon.currentSeason = currentSeason;

    await _saveMedias(medias);
  }
}

Future<bool>isSerieFinish(Media media) async {
  List<Media> medias = await getAllItems();
  int index = medias.indexWhere((m) => m.id == media.id);

  if (index != -1) {
    if(medias[index].serieAddon.currentSeason == media.serieAddon.finalSeason && medias[index].serieAddon.currentSequence == media.serieAddon.finalSequence){
      return true;
    }
  }
  return false;
}
