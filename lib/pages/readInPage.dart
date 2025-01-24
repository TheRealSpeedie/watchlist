import 'package:flutter/material.dart';
import 'package:watchlist/models/media.dart';
import 'package:watchlist/models/genre.dart';
import 'package:watchlist/models/MediaCategory.dart';
import 'package:watchlist/utility/utility.dart';
import '../services/sharedPreferences.dart';
import '../models/page.dart';
import '../themes/mainTheme.dart';
import 'mediaPage.dart';

class ReadInPage extends StatefulWidget {
  final List<Media> medias;

  ReadInPage({Key? key, required this.medias}) : super(key: key);

  @override
  State<ReadInPage> createState() => _ReadInPageState();
}

class _ReadInPageState extends State<ReadInPage> {
  late List<Media> medias;

  @override
  void initState() {
    super.initState();
    medias = widget.medias;
  }

  Future<void> SaveAndReturn() async {
    await saveMedias(medias);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MediaPage(
          title: MainTitle,
          selectedIndex: 0,
          onPage: OnPage.MAIN,
        ),
      ),
    );
  }

  bool get _allComplete {
    return medias.every((media) =>
    media.category != MediaCategory.NOTSET &&
        media.genre != Genre.NOTSET);
  }

  /// Prüft, ob dieser Eintrag unvollständig ist
  bool _isMediaIncomplete(Media media) {
    return (media.category == MediaCategory.NOTSET ||
        media.genre == Genre.NOTSET);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eingelesene Daten bearbeiten'),
      ),

      body: ListView.builder(
        itemCount: medias.length,
        itemBuilder: (context, index) {
          final media = medias[index];
          final cardColor = _isMediaIncomplete(media)
              ? Color(0xFF8B0000)  // dunkles Rot
              : Color(0xFF10590A); // dunkles Grün

          return Card(
            color: cardColor, // Hintergrundfarbe entsprechend Zustand
            child: ExpansionTile(
              title: Text(media.name),
              subtitle: Text(
                '${media.category.getCapital()} | ${media.genre.getCapital()}',
              ),
              children: [
                // KATEGORIE
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Kategorie:  "),
                      Expanded(
                        child: DropdownButton<MediaCategory>(
                          isExpanded: true,
                          value: media.category,
                          items: MediaCategory.values.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(cat.getCapital()),
                            );
                          }).toList(),
                          onChanged: (newCat) {
                            setState(() {
                              media.category = newCat!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // GENRE
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Genre:       "),
                      Expanded(
                        child: DropdownButton<Genre>(
                          isExpanded: true,
                          value: media.genre,
                          items: Genre.values.map((g) {
                            return DropdownMenuItem(
                              value: g,
                              child: Text(g.getCapital()),
                            );
                          }).toList(),
                          onChanged: (newGenre) {
                            setState(() {
                              media.genre = newGenre!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // SERIEN-ANGABEN
                if (media.category == MediaCategory.SERIE) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Jetzige Folge'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: media.serieAddon.currentSequence.toString(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          media.serieAddon.currentSequence =
                              int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Jetzige Staffel'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: media.serieAddon.currentSeason.toString(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          media.serieAddon.currentSeason =
                              int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Letzte Folge'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: media.serieAddon.finalSequence.toString(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          media.serieAddon.finalSequence =
                              int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Letzte Staffel'),
                      keyboardType: TextInputType.number,
                      controller: TextEditingController(
                        text: media.serieAddon.finalSeason.toString(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          media.serieAddon.finalSeason =
                              int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _allComplete ? SaveAndReturn : null,
        backgroundColor: _allComplete ? primaryColor : Colors.grey,
        tooltip: _allComplete
            ? 'Speichern'
            : 'Bitte erst alle Kategorie- und Genre-Felder ausfüllen',
        child: Icon(Icons.save),
      ),
    );
  }
}
