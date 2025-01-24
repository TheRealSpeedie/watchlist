
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:watchlist/models/MediaCategory.dart';
import 'package:watchlist/models/genre.dart';
import 'package:watchlist/models/media.dart';
import 'package:watchlist/models/serieAddon.dart';
import 'package:watchlist/models/status.dart';
import 'package:watchlist/services/sharedPreferences.dart';

import '../utility/utility.dart';

Future<List<Media>> getMediasFromFile() async {
  List<Media> medias = [];
  int currentSeason = 0;
  int currentSequence = 0;

  var id = await getMediaWithHighestID();

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['txt'],
  );

  if (result == null) {
    return [];
  }

  final pickedFile = result.files.single;

  String content;

  if (pickedFile.bytes != null) {
    content = String.fromCharCodes(pickedFile.bytes!);
  } else if (pickedFile.path != null) {
    final file = File(pickedFile.path!);
    content = await file.readAsString();
  } else {
    return [];
  }

  List<String> lines = content.split("\n");
  for (var x = 0; x < lines.length; x++) {
    final line = lines[x];

    if (line.startsWith("[")) {
      var trimmedLine = line.substring(line.indexOf("]") + 1);
      (currentSeason, currentSequence) = extractSeasonAndSequence(trimmedLine);

      var addon = SerieAddon(
        startedWatching: null,
        currentSeason: currentSeason,
        currentSequence: currentSequence,
        finalSeason: 0,
        finalSequence: 0,
      );

      if (trimmedLine.contains("folge")) {
        trimmedLine = trimmedLine.substring(0, trimmedLine.indexOf("folge") - 1);
      }
      if (trimmedLine.startsWith(" ")) {
        trimmedLine = trimmedLine.substring(1);
      }
      if (addon.currentSeason != 0 || addon.currentSequence != 0) {
        medias.add(
          Media(
            id: id++,
            name: trimmedLine,
            genre: Genre.NOTSET,
            watched: Status.WATCHING,
            category: MediaCategory.SERIE,
            serieAddon: addon,
          ),
        );
      } else if (line.contains("[v]")) {
        medias.add(
          Media(
            id: id++,
            name: trimmedLine,
            genre: Genre.NOTSET,
            watched: Status.WATCHED,
            category: MediaCategory.NOTSET,
            watchedDate: DateTime.fromMillisecondsSinceEpoch(0),
            serieAddon: addon,
          ),
        );
      } else {
        medias.add(
          Media(
            id: id++,
            name: trimmedLine,
            genre: Genre.NOTSET,
            watched: Status.NOTWATCHED,
            category: MediaCategory.NOTSET,
            serieAddon: addon,
          ),
        );
      }
    }
  }
  return medias;
}
