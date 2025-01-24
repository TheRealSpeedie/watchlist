

import 'package:intl/intl.dart';

class SerieAddon {
  int currentSequence;
  int currentSeason;
  int finalSequence;
  int finalSeason;
  double percentage = 0.0;
  DateTime? startedWatching;

  SerieAddon({required this.startedWatching, required this.currentSeason, required this.currentSequence,  required this.finalSeason, required this.finalSequence});

  factory SerieAddon.fromJson(Map<String, dynamic> json) {
    return SerieAddon(
      currentSeason: int.parse(json["currentSeason"]),
      currentSequence: int.parse(json["currentSequence"]),
      finalSeason: int.parse(json["finalSeason"]),
      finalSequence: int.parse(json["finalSequence"]),
      startedWatching: json['startedWatching'] != null ? DateTime.parse(json['startedWatching']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentSeason': currentSeason.toString(),
      'currentSequence':currentSequence.toString(),
      'finalSeason':finalSeason.toString(),
      'finalSequence':finalSequence.toString(),
      'startedWatching': startedWatching?.toIso8601String(),
    };
  }
  String ConvertStartWatchingDate(){
    if(startedWatching == null){
      return "Unbekannt";
    }else{
      return DateFormat("dd.MM.yyyy").format(startedWatching!);}
  }
}
