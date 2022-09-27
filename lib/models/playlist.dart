import 'package:parse_playlist/models/song.dart';

class Playlist {
  final String title;
  final String playlistImage;
  final String description;
  final List<Song> songs;
  Playlist({
    required this.title,
    required this.playlistImage,
    required this.description,
    required this.songs,
  });
}
