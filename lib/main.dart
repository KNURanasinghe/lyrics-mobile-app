import 'package:flutter/material.dart';
import 'package:lyrics/Screens/DrawerScreens/how_ro_read_lyrics.dart';
import 'package:lyrics/Screens/DrawerScreens/privacy_policy.dart';
import 'package:lyrics/Screens/DrawerScreens/worship_note_screen.dart';
import 'package:lyrics/Screens/HomeScreen/home_screen.dart';
import 'package:lyrics/Screens/add_note_screen.dart';
import 'package:lyrics/Screens/all_songs.dart';
import 'package:lyrics/Screens/language_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lyrics App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomePage(),
    );
  }
}
