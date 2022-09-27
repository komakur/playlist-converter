import 'package:flutter/material.dart';
import 'package:html/dom.dart' as html;
import 'package:parse_playlist/models/playlist.dart';
import 'package:parse_playlist/ui/screens/playlist_screen.dart';

import 'package:parse_playlist/utils/playlist_parser.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _urlTextController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _urlTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF191414),
        title: const Text('Playlist Parser'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? const CircularProgressIndicator(
                    color: Color(0xFF1DB954),
                  )
                : const Text(
                    'Enter URL of playlist',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Playlist URL...',
                ),
                controller: _urlTextController,
              ),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() {
                        isLoading = true;
                      });
                      var doc = await PlaylistParser.getHTMLDocFromPage(
                          // uri: 'https://open.spotify.com/album/1qwlxZTNLe1jq3b0iidlue');
                          // 'https://open.spotify.com/playlist/3dpOdyAk3AVSSc0CqXQEA6');
                          uri: _urlTextController.text);
                      Playlist playlist = await PlaylistParser.toPlayList(doc);
                      setState(() {
                        isLoading = false;
                      });
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaylistScreen(
                              playlist: playlist,
                            ),
                          ),
                        );
                      }
                    },
              child: const Text('Get Playlist'),
            ),
          ],
        ),
      ),
    );
  }
}
