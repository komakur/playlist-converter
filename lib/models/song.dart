import 'package:html/dom.dart';
import 'package:parse_playlist/models/album.dart';
import 'package:parse_playlist/utils/playlist_parser.dart';

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

  // factory Song.fromDocument(Document doc) {
  //   final songTitle = PlaylistParser.findContentByMetaProperty(
  //       doc: doc, property: 'og:title');
  //   final artist = PlaylistParser.findContentByMetaProperty(
  //           doc: doc, property: 'og:description')
  //       .replaceAll(RegExp(r' · Song · \d+'), '');
  //   final duration =
  //       PlaylistParser.findContentByMetaName(doc: doc, name: 'music:duration');
  //   final albumURL =
  //       PlaylistParser.findContentByMetaName(doc: doc, name: 'music:album');
  //   return Song(
  //       name: songTitle, artist: artist, album: albumURL, duration: duration);
  // }
}
