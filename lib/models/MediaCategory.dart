enum MediaCategory{
  MOVIE, SERIE, NOTSET;

  String getCapital() {
    return "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
  }
  static List<MediaCategory> getSelectableValues() {
    return MediaCategory.values
        .where((value) => value != MediaCategory.NOTSET)
        .toList();
  }
}
