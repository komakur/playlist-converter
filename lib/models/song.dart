import 'package:parse_playlist/models/album.dart';

class Song {
  final String name;
  final String artist;
  final Album album;
  final String duration;

  Song({
    required this.name,
    required this.artist,
    required this.album,
    required this.duration,
  });
}
