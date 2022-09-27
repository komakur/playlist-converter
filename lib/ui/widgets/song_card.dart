import 'package:flutter/material.dart';
import 'package:parse_playlist/ui/screens/playlist_screen.dart';
import 'package:parse_playlist/ui/widgets/song_details.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    Key? key,
    required this.widget,
    required this.index,
  }) : super(key: key);

  final PlaylistScreen widget;
  final int index;

  //formatting duration to hh:mm:ss
  String formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(0, '2');
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (int.parse(hours) == 0) {
      return "$minutes:$seconds";
    }
    return "$hours:$minutes:$seconds";
  }

  //getting duration from string of seconds
  Duration duration(String songDurationInSec) {
    int sec = int.tryParse(songDurationInSec) ?? 0;
    return Duration(seconds: sec);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: MediaQuery.of(context).size.height / 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.playlist.songs[index].name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(widget.playlist.songs[index].artist),
              ],
            ),
          ),
          Text(formatDuration(duration(widget.playlist.songs[index].duration))),
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) =>
                      SongDetails(widget: widget, index: index));
            },
            icon: const Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
    );
  }
}
