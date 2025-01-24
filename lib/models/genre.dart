enum Genre{
  ACTION,
  KRIMI,
  DRAMA,
  FANTASY,
  HORROR,
  COMEDY,
  ROMANCE,
  SCIENCEFICTION,
  SPORT,
  THRILLER,
  MYSTERY,
  WAR,
  WESTERN,
  NOTSET,
  ANIME;

  String getCapital() {
      return "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
  }
  static List<Genre> getSelectableValues() {
    return Genre.values
        .where((value) => value != Genre.NOTSET)
        .toList();
  }
}

