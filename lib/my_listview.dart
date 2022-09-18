import 'dart:io';
import 'package:flutter/material.dart';
import 'package:soundays/models/recommendations.dart';
import 'package:soundays/current_song.dart';

class MyListView extends StatelessWidget {
  final Recommendation songData;
  //final List<MaterialColor> _colors = Colors.primaries;

  const MyListView({required this.songData});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: songData.tracks.length,
      itemBuilder: (context, int index) {
        var s = songData.tracks[index];
        var myindex = index;
        //final MaterialColor color = _colors[index % _colors.length];
        var album_pic = s.album.images[0].url;
        //s.albumArt == null ? null : File.fromUri(Uri.parse(s.albumArt));

        return ListTile(
          dense: false,
          //tileColor: color.shade200,
          leading: CircleAvatar(
            backgroundImage: album_pic == null ? NetworkImage('https://i.scdn.co/image/ab67616d0000b273c5015d2a9270865a5979f56b')
                                                : NetworkImage(album_pic), //AssetImage('assets/some_album.jpg'),
            radius: 30.0,
            //tag: s.title,
          ),
          title: Text(s.name, style: TextStyle(fontSize: 14.0, fontFamily: "Poppins",)) ,
          subtitle: Text("By ${s.artists[0].name}", style: TextStyle(fontSize: 14.0, fontFamily: "Poppins", color: Color(0xFFB1B1B1))),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CurrentSong(songData, s, myindex)));
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Divider(
            height: 10,
            color: Colors.grey[800],
          ),
        );
      },
    );
  }
}