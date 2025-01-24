enum Status{
  WATCHED, WATCHING, NOTWATCHED;

  String getCapital() {
    return "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
  }
}