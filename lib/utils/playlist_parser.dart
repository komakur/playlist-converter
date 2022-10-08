import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:parse_playlist/models/album.dart';
import 'package:parse_playlist/models/playlist.dart';
import 'package:parse_playlist/models/song.dart';
import 'package:parse_playlist/network/network.dart';

abstract class PlaylistParser {
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

  // get playlist songs urls
  static List<String> _getPlaylistSongsUrls({required Document doc}) {
    // main div for all songs
    final songsDivs = doc.body!
        .querySelector('#main')!
        .children[0]
        .children[0]
        .children[0]
        .children[0]
        .children[0]
        .children[2]
        .children[0]
        .children[0]
        .children[1]
        .children;

    final List<String> songsUrls = songsDivs
        .map((songDiv) => songDiv.children[0].children[1].children[0]
            .children[0].children[0].children[0].attributes['href']!)
        .toList();

    return songsUrls;
  }

  //get specific meta content from specific document of specific property
  static String _findContentByMetaProperty(
          {required Document doc, required String property}) =>
      doc
          .getElementsByTagName('head')
          .first
          .getElementsByTagName('meta')
          .firstWhere((element) => element.attributes['property'] == property)
          .attributes['content']!;

//get specific meta content from specific document of specific name
  static dynamic _findContentByMetaName({
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

  //parse document to album
  static Future<Album> albumFromDocument(Document doc) async {
    final title = _findContentByMetaProperty(doc: doc, property: 'og:title');
    return Album(title: title);
  }

  //convert document to playlist
  static Future<Playlist> playlistFromDocument(Document doc) async {
    try {
      final title = _findContentByMetaProperty(doc: doc, property: 'og:title');
      String description = '';

      if (_findContentByMetaName(doc: doc, name: 'description')
          .contains('Listen on Spotify')) {
        description = _findContentByMetaName(
                doc: doc, name: 'description', isSongs: false)
            .replaceRange(0, 18, '');
      } else {
        description = _findContentByMetaName(
            doc: doc, name: 'description', isSongs: false);
      }
      final photoURL =
          _findContentByMetaProperty(doc: doc, property: 'og:image');
      final songsURLs = _getPlaylistSongsUrls(doc: doc);

      return Playlist(
        title: title,
        playlistImage: photoURL,
        description: description,
        songs: songsURLs,
      );
    } catch (e) {
      rethrow;
    }
  }

  //convert document to song
  static Stream<Song> songFromUrl(String url) async* {
    final doc = await getHTMLDocFromPage(uri: url);
    final songTitle = PlaylistParser._findContentByMetaProperty(
        doc: doc, property: 'og:title');
    final artist = PlaylistParser._findContentByMetaProperty(
            doc: doc, property: 'og:description')
        .replaceAll(RegExp(r' · Song · \d+'), '');
    // get song duration
    final duration =
        PlaylistParser._findContentByMetaName(doc: doc, name: 'music:duration');
    // get song album
    final Album album = await albumFromDocument(await getHTMLDocFromPage(
      uri: PlaylistParser._findContentByMetaName(doc: doc, name: 'music:album'),
    ));

    yield Song(
        name: songTitle, artist: artist, album: album, duration: duration);
  }
}
