import 'package:flutter/material.dart';
import 'package:test_zero/models/recommendations.dart';
import 'package:test_zero/models/track.dart';

enum PlayerState { stopped, playing, paused }

class CurrentSong extends StatefulWidget {
  final Track _song;
  final Recommendation songData;

  const CurrentSong(this.songData, this._song);

  @override
  _CurrentSongState createState() => _CurrentSongState();
}

class _CurrentSongState extends State<CurrentSong> {
  // MusicFinder audioPlayer;
  // Duration duration;
  // Duration position;
  // PlayerState playerState;
  late Track song;
  bool isMuted = true;
  //
  // get isPlaying => playerState == PlayerState.playing;
  // get isPaused => playerState == PlayerState.paused;
  //
  // get durationText =>
  //     duration != null ? duration.toString().split('.').first : '';
  // get positionText =>
  //     position != null ? position.toString().split('.').first : '';
  //
  // bool isMuted = false;

  @override
  initState() {
    super.initState();
    //initPlayer();
    song = widget._song;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void onComplete() {
  //   setState(() => playerState = PlayerState.stopped);
  //   play(widget.songData.nextSong);
  // }
  //
  // initPlayer() async {
  //   if (audioPlayer == null) {
  //     audioPlayer = widget.songData.audioPlayer;
  //   }
  //   setState(() {
  //     song = widget._song;
  //     if (widget.nowPlayTap == null || widget.nowPlayTap == false) {
  //       if (playerState != PlayerState.stopped) {
  //         stop();
  //       }
  //     }
  //     play(song);
  //     //  else {
  //     //   widget._song;
  //     //   playerState = PlayerState.playing;
  //     // }
  //   });
  //   audioPlayer.setDurationHandler((d) => setState(() {
  //     duration = d;
  //   }));
  //
  //   audioPlayer.setPositionHandler((p) => setState(() {
  //     position = p;
  //   }));
  //
  //   audioPlayer.setCompletionHandler(() {
  //     onComplete();
  //     setState(() {
  //       position = duration;
  //     });
  //   });
  //
  //   audioPlayer.setErrorHandler((msg) {
  //     setState(() {
  //       playerState = PlayerState.stopped;
  //       duration = new Duration(seconds: 0);
  //       position = new Duration(seconds: 0);
  //     });
  //   });
  // }
  //
  // Future play(Song s) async {
  //   if (s != null) {
  //     final result = await audioPlayer.play(s.uri, isLocal: true);
  //     if (result == 1)
  //       setState(() {
  //         playerState = PlayerState.playing;
  //         song = s;
  //       });
  //   }
  // }
  //
  // Future pause() async {
  //   final result = await audioPlayer.pause();
  //   if (result == 1) setState(() => playerState = PlayerState.paused);
  // }
  //
  // Future stop() async {
  //   final result = await audioPlayer.stop();
  //   if (result == 1)
  //     setState(() {
  //       playerState = PlayerState.stopped;
  //       position = new Duration();
  //     });
  // }
  //
  // Future next(SongData s) async {
  //   stop();
  //   setState(() {
  //     play(s.nextSong);
  //   });
  // }
  //
  // Future prev(SongData s) async {
  //   stop();
  //   play(s.prevSong);
  // }
  //
  // Future mute(bool muted) async {
  //   final result = await audioPlayer.mute(muted);
  //   if (result == 1)
  //     setState(() {
  //       isMuted = muted;
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    Widget _buildPlayer() => Container(
        padding: EdgeInsets.all(20.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(
            children: <Widget>[
              Text(
                song.name,
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                song.artists[0].name,
                style: Theme.of(context).textTheme.caption,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
              )
            ],
          ),
          // Row(mainAxisSize: MainAxisSize.min, children: [
          //   ControlButton(Icons.skip_previous, () => prev(widget.songData)),
          //   ControlButton(isPlaying ? Icons.pause : Icons.play_arrow,
          //       isPlaying ? () => pause() : () => play(widget._song)),
          //   ControlButton(Icons.skip_next, () => next(widget.songData)),
          // ]),
          // duration == null
          //     ? Container()
          //     : Slider(
          //     value: position?.inMilliseconds?.toDouble() ?? 0,
          //     onChanged: (double value) =>
          //         audioPlayer.seek((value / 1000).roundToDouble()),
          //     min: 0.0,
          //     max: duration.inMilliseconds.toDouble()),
          // Row(mainAxisSize: MainAxisSize.min, children: [
          //   Text(
          //       position != null
          //           ? "${positionText ?? ''} / ${durationText ?? ''}"
          //           : duration != null ? durationText : '',
          //       // ignore: conflicting_dart_import
          //       style: TextStyle(fontSize: 24.0))
          // ]),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  icon: isMuted
                      ? Icon(
                    Icons.headset,
                    color: Theme.of(context).unselectedWidgetColor,
                  )
                      : Icon(Icons.headset_off,
                      color: Theme.of(context).unselectedWidgetColor),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    //mute(!isMuted);
                  }),
              // new IconButton(
              //     onPressed: () => mute(true),
              //     icon: new Icon(Icons.headset_off),
              //     color: Colors.cyan),
              // new IconButton(
              //     onPressed: () => mute(false),
              //     icon: new Icon(Icons.headset),
              //     color: Colors.cyan),
            ],
          ),
        ]));

    var playerUI = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          //AlbumUI(song, duration, position),
          Material(
            child: _buildPlayer(),
            color: Colors.transparent,
          ),
        ]);

    return Scaffold(
      appBar: AppBar(
        title: Text("Now Playing"),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[playerUI],
        ),
      ),
    );
  }
}