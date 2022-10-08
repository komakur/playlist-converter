import 'package:flutter/material.dart';

class SongDetails extends StatelessWidget {
  const SongDetails({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  final AsyncSnapshot snapshot;

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
                    text: '\n${snapshot.data.album.title}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
