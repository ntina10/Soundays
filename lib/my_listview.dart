import 'dart:io';
import 'package:flutter/material.dart';
import 'package:soundays/models/recommendations.dart';
import 'package:soundays/models/track.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';


class MyListView extends StatefulWidget {
  final Recommendation songData;
  //final List<MaterialColor> _colors = Colors.primaries;

  const MyListView({required this.songData});

  @override
  _MyListViewState createState() => _MyListViewState();
}



class _MyListViewState extends State<MyListView> {

  late List<int> values;

  late Recommendation songData;

  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration(seconds: 20);
  late Duration position;

  get isPlaying => audioPlayer.state == PlayerState.playing;
  get isPaused => audioPlayer.state == PlayerState.paused;

  List<bool> audiostatus = [];

  @override
  void initState() {
    songData = widget.songData;
    for(var i = 0; i<songData.tracks.length; i++) {
      audiostatus.add(false);
    }
    //hasPreview = song.previewUrl != '';
    initPlayer();
  }

  void onComplete() {
    setState(() => audioPlayer.state = PlayerState.stopped);
    for (int i = 0; i < audiostatus.length; i++) {
      audiostatus[i] = false;
    }
    //play(widget.songData.nextSong);
  }

  initPlayer() async {
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: ' + d.inSeconds.toString());
      setState(() => duration = d);
    });

    audioPlayer.onPositionChanged.listen((positionValue) {
      print('Position new: ' + positionValue.inSeconds.toString());
      setState(() => position = positionValue);
      //updatePlayerBar();
    });

    if(audioPlayer.state == PlayerState.completed) {
      onComplete();
    }

    audioPlayer.onPlayerComplete.listen((event) {
      onComplete();
      setState(() {
        position = duration;
      });
    });

  }

  Future play(Track s) async {
    print("the track" + s.toString());
    print("the url" + s.previewUrl);

    //if playerState isPlaying then stop kai set state gia to epomeno tragoudi

    await audioPlayer.play(UrlSource(s.previewUrl)); //both lines work

    //await audioPlayer.resume();
    setState(() => audioPlayer.state = PlayerState.playing);
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => audioPlayer.state = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      audioPlayer.state = PlayerState.stopped;
      position = new Duration();
    });
  }

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
            //AssetImage('no_album.png'),
            backgroundImage: album_pic == null ? NetworkImage('https://i.scdn.co/image/ab67616d0000b273c5015d2a9270865a5979f56b')
                                               : NetworkImage(album_pic), //AssetImage('assets/some_album.jpg'),
            radius: 30.0,
          ),
          title: Text(s.name, style: TextStyle(fontSize: 14.0, fontFamily: "Poppins",)) ,
          subtitle: Text("By ${s.artists[0].name}", style: TextStyle(fontSize: 14.0, fontFamily: "Poppins", color: Color(0xFFB1B1B1))),
          // onTap: () {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => CurrentSong(songData, s, myindex)));
          // },
          trailing: s.previewUrl != '' ?
          Stack(
            children: [
              Positioned(
                top: 6,
                  right: 6,
                  child: CircularProgressIndicator(value: audiostatus[index] ? position.inSeconds/duration.inSeconds : 0.0, strokeWidth: 2, backgroundColor: Colors.grey, color: Colors.green,)
              ),
              IconButton(icon: audiostatus[index] ? const Icon(Icons.pause_rounded, color: Colors.green,) : const Icon(Icons.play_arrow_rounded),
                          onPressed: audiostatus[index]
                                      ? () { pause(); setState(() {
                                                        audiostatus[index] = false;
                                      }); }
                              : () { play(s); setState(() {
                                                  for (int i = 0; i < audiostatus.length; i++) {
                                                    audiostatus[i] = false;
                                                  }
                                                  position = new Duration();
                                                  audiostatus[index] = true;
                                              });
                                    }
                          ),
            ],
          )
          : null
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

class AudioFile {
  String url;
  bool playingstatus;

  AudioFile({required this.url, required this.playingstatus});
}