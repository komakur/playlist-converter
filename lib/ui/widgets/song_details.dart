import 'package:flutter/material.dart';
import 'package:parse_playlist/ui/screens/playlist_screen.dart';

class SongDetails extends StatelessWidget {
  const SongDetails({
    Key? key,
    required this.widget,
    required this.index,
  }) : super(key: key);

  final PlaylistScreen widget;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(child: Text('Song info')),
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                      text: 'Album',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0)),
                  TextSpan(
                      text: '\n${widget.playlist.songs[index].album.title}',
                      style: const TextStyle(color: Colors.black87)),
                ],
              ),
            )),
      ],
    );
  }
}
