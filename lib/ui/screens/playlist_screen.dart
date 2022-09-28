import 'package:flutter/material.dart';
import 'package:parse_playlist/models/playlist.dart';
import 'package:parse_playlist/ui/widgets/song_card.dart';

class PlaylistScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistScreen({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List docs = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF191414),
        title: const Text('Playlist Parser'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.playlist.playlistImage),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      color: Colors.black,
                      child: Text(
                        widget.playlist.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0),
                      ),
                    ),
                    Container(
                      color: Colors.black,
                      child: Text(
                        widget.playlist.description,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 20.0),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.playlist.songs.length,
              itemBuilder: (context, int index) {
                return SongCard(
                  widget: widget,
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
