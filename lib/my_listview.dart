import 'dart:io';
import 'package:flutter/material.dart';
import 'package:test_zero/models/recommendations.dart';
import 'package:test_zero/current_song.dart';

class MyListView extends StatelessWidget {
  final Recommendation songData;
  final List<MaterialColor> _colors = Colors.primaries;

  const MyListView({required this.songData});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songData.tracks.length,
      itemBuilder: (context, int index) {
        var s = songData.tracks[index];
        final MaterialColor color = _colors[index % _colors.length];
        //var artFile =
        //s.albumArt == null ? null : File.fromUri(Uri.parse(s.albumArt));

        return ListTile(
          dense: false,
          // leading: Hero(
          //   child: avatar(artFile, s.title, color),
          //   tag: s.title,
          // ),
          title: Text(s.name) ,
          subtitle: Text(
            "By ${s.artists[0].name}",
            style: Theme.of(context).textTheme.caption,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CurrentSong(songData, s)));
          },
        );
      },
    );
  }
}