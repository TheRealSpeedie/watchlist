import 'package:flutter/material.dart';
import '../models/genre.dart';

class FilterPage extends StatefulWidget {
  final List<Genre> selectedGenres;
  final Function(List<Genre>) onGenresSelected;

  const FilterPage({required this.selectedGenres, required this.onGenresSelected});

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  late List<Genre> selectedGenres;

  @override
  void initState() {
    super.initState();
    selectedGenres = widget.selectedGenres;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Genre Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wählen Sie die Genres aus:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: Genre.values.map((genre) {
                  return CheckboxListTile(
                    title: Text(genre.toString().split('.').last),
                    value: selectedGenres.contains(genre),
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected != null) {
                          if (selected) {
                            selectedGenres.add(genre);
                          } else {
                            selectedGenres.remove(genre);
                          }
                        }
                        widget.onGenresSelected(selectedGenres); // notify parent
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
