import 'package:flutter/material.dart';
import 'package:watchlist/models/media.dart';
import 'package:watchlist/models/serieAddon.dart';
import 'package:watchlist/models/status.dart';

import '../models/MediaCategory.dart';
import '../models/genre.dart';
import '../services/sharedPreferences.dart';
import '../utility/utility.dart';

class AddMediaScreen extends StatefulWidget {
  final VoidCallback onMediaAdded;

  const AddMediaScreen({super.key, required this.onMediaAdded});

  @override
  _AddMediaScreen createState() => _AddMediaScreen();
}

class _AddMediaScreen extends State<AddMediaScreen> {
  final TextEditingController _MediaNameController = TextEditingController();
  Genre? _selectedGenre = Genre.ACTION;
  MediaCategory _selectedCategory = MediaCategory.MOVIE;
  Status _watched = Status.NOTWATCHED;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentSequenceController = TextEditingController();
  final TextEditingController _currentSeasonController = TextEditingController();
  final TextEditingController _finalSequenceController = TextEditingController();
  final TextEditingController _finalSeasonController = TextEditingController();

  int finalSeason = 0;
  int finalSequence = 0;
  int currentSeason = 1;
  int currentSequence = 0;

  @override
  void initState() {
    super.initState();

    _currentSequenceController.text = currentSequence.toString();
    _currentSeasonController.text = currentSeason.toString();
    _finalSequenceController.text = finalSequence.toString();
    _finalSeasonController.text = finalSeason.toString();
  }

  void _saveMedia() async {
    var id = await getMediaWithHighestID();

    if(currentSequence != 0 || currentSeason != 1){
      _watched = Status.WATCHING;
    }
    var addon = SerieAddon(startedWatching: null, currentSeason: currentSeason, currentSequence: currentSequence, finalSeason: finalSeason, finalSequence: finalSequence);
    Media media = Media(id: id+1,name: _MediaNameController.text, genre: _selectedGenre!, watched: _watched, category: _selectedCategory, serieAddon: addon);
    await saveMedia(media);
    if (_formKey.currentState?.validate() ?? false) {
      message('Medium "${_MediaNameController.text}" mit Genre "${_selectedGenre?.getCapital()}" gespeichert!', context);
      widget.onMediaAdded();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text("Medium Hinzufügen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget>[
              TextFormField(
                controller: _MediaNameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte geben Sie den Namen des Mediums ein';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<MediaCategory>(
                value: _selectedCategory,
                onChanged: (MediaCategory? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Kategorie auswählen',
                  border: OutlineInputBorder(),
                ),
                items: MediaCategory.getSelectableValues().map<DropdownMenuItem<MediaCategory>>((MediaCategory value) {
                  return DropdownMenuItem<MediaCategory>(
                    value: value,
                    child: Text(value.getCapital()),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Genre>(
                value: _selectedGenre,
                onChanged: (Genre? newValue) {
                  setState(() {
                    _selectedGenre = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Genre auswählen',
                  border: OutlineInputBorder(),
                ),
                items: Genre.getSelectableValues().map<DropdownMenuItem<Genre>>((Genre value) {
                  return DropdownMenuItem<Genre>(
                    value: value,
                    child: Text(value.getCapital()),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),if (_selectedCategory == MediaCategory.SERIE) ...[
                TextField(
                  controller: _currentSequenceController,
                  decoration: InputDecoration(labelText: 'Jetzige Folge'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    currentSequence = int.tryParse(value) ?? 0;
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _currentSeasonController,
                  decoration: InputDecoration(labelText: 'Jetzige Staffel'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    currentSeason = int.tryParse(value) ?? 0;
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _finalSequenceController,
                  decoration: InputDecoration(labelText: 'Letzte Folge'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    finalSequence = int.tryParse(value) ?? 0;
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _finalSeasonController,
                  decoration: InputDecoration(labelText: 'Letze Staffel'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    finalSeason = int.tryParse(value) ?? 0;
                  },
                ),
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveMedia,
                child: Text('Speichern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
