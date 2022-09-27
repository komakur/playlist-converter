import 'package:flutter/material.dart';
import 'package:parse_playlist/ui/screens/home_screen.dart';
import 'package:parse_playlist/ui/screens/playlist_screen.dart';
import 'package:parse_playlist/utils/playlist_parser.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
