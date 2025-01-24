import 'package:flutter/material.dart';
import 'package:watchlist/models/page.dart';
import 'package:watchlist/pages/mediaPage.dart';
import 'package:watchlist/themes/mainTheme.dart';
import 'package:watchlist/utility/utility.dart';

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
      debugShowCheckedModeBanner: false,
      home:  MediaPage(title: MainTitle, selectedIndex: 0, onPage: OnPage.MAIN,),
    );
  }
}

