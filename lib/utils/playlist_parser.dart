import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:parse_playlist/models/album.dart';
import 'package:parse_playlist/models/playlist.dart';
import 'package:parse_playlist/models/song.dart';
import 'package:parse_playlist/network/network.dart';

class PlaylistParser {
  //getting Document from url
  static Future<Document> getHTMLDocFromPage({required String uri}) async {
    final response = await Network.getResponse(uri: uri);
    if (response.statusCode == 200) {
      final doc = parse(response.body);
      return doc;
    } else {
      throw Exception('Failed To get Document');
    }
  }

  //get specific meta content from specific document of specific property
  static String findContentByMetaProperty(
      {required Document doc, required String property}) {
    return doc
        .getElementsByTagName('head')
        .first
        .getElementsByTagName('meta')
        .firstWhere((element) => element.attributes['property'] == property)
        .attributes['content']!;
  }

//get specific meta content from specific document of specific name
  static dynamic findContentByMetaName({
    required Document doc,
    required String name,
    bool isSongs = false,
  }) {
    if (isSongs) {
      var songs = <String>[];
      doc
          .getElementsByTagName('head')
          .first
          .getElementsByTagName('meta')
          .where((element) => element.attributes['name'] == name)
          .forEach((element) {
        songs.add(element.attributes['content']!);
      });

      return songs;
    } else {
      return doc
          .getElementsByTagName('head')
          .first
          .getElementsByTagName('meta')
          .firstWhere((element) => element.attributes['name'] == name)
          .attributes['content']!;
    }
  }

  //convert document fo playlist
  static Future<Playlist> toPlayList(Document doc) async {
    final title = findContentByMetaProperty(doc: doc, property: 'og:title');
    String description = '';

    if (findContentByMetaName(doc: doc, name: 'description')
        .contains('Listen on Spotify')) {
      description =
          findContentByMetaName(doc: doc, name: 'description', isSongs: false)
              .replaceRange(0, 18, '');
    } else {
      description =
          findContentByMetaName(doc: doc, name: 'description', isSongs: false);
    }
    final photoURL = findContentByMetaProperty(doc: doc, property: 'og:image');
    final songsURLs =
        findContentByMetaName(doc: doc, name: 'music:song', isSongs: true);

    List<Song> songs = [];
    for (int i = 0; i < songsURLs.length; i++) {
      final songDoc = await getHTMLDocFromPage(uri: songsURLs[i]);
      final song = await songFromDocument(songDoc);
      songs.add(song);
    }

    return Playlist(
      title: title,
      playlistImage: photoURL,
      description: description,
      songs: songs,
    );
  }

  //convert document to song
  static Future<Song> songFromDocument(Document doc) async {
    final songTitle = PlaylistParser.findContentByMetaProperty(
        doc: doc, property: 'og:title');
    final artist = PlaylistParser.findContentByMetaProperty(
            doc: doc, property: 'og:description')
        .replaceAll(RegExp(r' · Song · \d+'), '');
    final duration =
        PlaylistParser.findContentByMetaName(doc: doc, name: 'music:duration');
    final Album album = await albumFromDocument(await getHTMLDocFromPage(
      uri: PlaylistParser.findContentByMetaName(doc: doc, name: 'music:album'),
    ));

    return Song(
        name: songTitle, artist: artist, album: album, duration: duration);
  }

  //convert document to album
  static Future<Album> albumFromDocument(Document doc) async {
    final title = findContentByMetaProperty(doc: doc, property: 'og:title');
    return Album(title: title);
  }
}
