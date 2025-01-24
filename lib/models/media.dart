import 'package:intl/intl.dart';
import 'package:watchlist/models/MediaCategory.dart';
import 'package:watchlist/models/serieAddon.dart';
import 'package:watchlist/models/status.dart';

import 'genre.dart';

class Media {
  int id;
  String name;
  Genre genre;
  Status watched;
  DateTime? watchedDate;
  MediaCategory category;
  SerieAddon serieAddon;

  Media({required this.id,required this.name, required this.genre, required this.watched, this.watchedDate, required this.category, required this.serieAddon});

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['id'],
      name: json['MediaName'],
      genre: Genre.values.firstWhere((e) => e.toString() == 'Genre.' + json['genre']),
      watched: Status.values.firstWhere((e) => e.toString() == 'Status.' + json['watched']),
      watchedDate: json['watchedDate'] != null ? DateTime.parse(json['watchedDate']) : null,
      category: MediaCategory.values.firstWhere((e) => e.toString() == 'MediaCategory.' + json['category']),
      serieAddon: SerieAddon.fromJson(json["serieAddon"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'MediaName': name,
      'genre': genre.toString().split('.').last,
      'watched': watched.toString().split('.').last,
      'watchedDate': watchedDate?.toIso8601String(),
      'category': category.toString().split('.').last,
      'serieAddon': serieAddon.toJson(),
    };
  }
  String ConvertStartWatchingDate(){
    if(watchedDate == DateTime.fromMillisecondsSinceEpoch(0)){
      return "Unbekannt";
    }else{
      return DateFormat("dd.MM.yyyy").format(watchedDate!);}
  }
}
