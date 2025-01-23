import 'package:flutter/material.dart';
import 'package:watchlist/pages/moviePage.dart';
import 'package:watchlist/themes/mainTheme.dart';
import 'package:watchlist/utility.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watchlist',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
      ),
      home:  MoviePage(title: MainTitle, selectedIndex: 0),
    );
  }
}

