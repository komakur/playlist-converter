import 'package:flutter/material.dart';
import 'package:parse_playlist/ui/widgets/song_details.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final AsyncSnapshot snapshot;

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
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(width: 1.0),
        ),
        color: Colors.white60,
      ),
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
                  snapshot.data.name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(snapshot.data.artist),
              ],
            ),
          ),
          Text(
            formatDuration(
              duration(snapshot.data.duration),
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SongDetails(snapshot: snapshot),
              );
            },
            icon: const Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
    );
  }
}
