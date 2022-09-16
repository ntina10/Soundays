import 'package:flutter/material.dart';
import 'package:soundays/models/recommendations.dart';
import 'package:soundays/models/track.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';

//enum PlayerState { stopped, playing, paused }

class CurrentSong extends StatefulWidget {
  final Track _song;
  final Recommendation _songData;
  final int _idx;

  const CurrentSong(this._songData, this._song, this._idx);

  @override
  _CurrentSongState createState() => _CurrentSongState();
}

class _CurrentSongState extends State<CurrentSong> {
  AudioPlayer audioPlayer = AudioPlayer();
  // Duration duration;
  // Duration position;
  //PlayerState plState; //audioPlayer.state
  late Track song;
  late int idx;
  late Recommendation songData;

  bool isMuted = false;

  late bool hasPreview;

  get isPlaying => audioPlayer.state == PlayerState.playing;
  get isPaused => audioPlayer.state == PlayerState.paused;
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

    song = widget._song;
    idx = widget._idx;
    songData = widget._songData;
    hasPreview = song.previewUrl != '';
    initPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void onComplete() {
    setState(() => audioPlayer.state = PlayerState.stopped);
    //play(widget.songData.nextSong);
  }

  initPlayer() async {

    //await audioPlayer.setSourceUrl(song.previewUrl);

    // setState(() {
    //   song = widget._song;
    //   if (widget.nowPlayTap == null || widget.nowPlayTap == false) {
    //     if (playerState != PlayerState.stopped) {
    //       stop();
    //     }
    //   }
    //   play(song);
    //   //  else {
    //   //   widget._song;
    //   //   playerState = PlayerState.playing;
    //   // }
    // });
  //   audioPlayer.setDurationHandler((d) => setState(() {
  //     duration = d;
  //   }));
  //
  //   audioPlayer.setPositionHandler((p) => setState(() {
  //     position = p;
  //   }));

    if(audioPlayer.state == PlayerState.completed) {
      onComplete();
    }

    audioPlayer.onPlayerComplete.listen((event) {
      onComplete();
      // setState(() {
      //   position = duration;
      // });
    });

  }

  Future play(Track s) async {
    print("the track" + s.toString());
    print("the url" + s.previewUrl);
    if (s.previewUrl == '') {
      print("No preview is available");
    } else {
      await audioPlayer.play(UrlSource(s.previewUrl)); //both lines work
      //await audioPlayer.resume();
      setState(() => audioPlayer.state = PlayerState.playing);
    }
  }
  Future pause() async {
    await audioPlayer.pause();
    setState(() => audioPlayer.state = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      audioPlayer.state = PlayerState.stopped;
      //position = new Duration();
    });
  }


  // Future stop() async {
  //   val result = await audioPlayer.stop();
  //   if (result == 1)
  //     setState(() {
  //       playerState = PlayerState.stopped;
  //       //position = new Duration();
  //     });
  // }

  Future next(Recommendation s) async {
    stop();
    setState(() {
      //play(s.nextSong);
      song = songData.tracks[idx+1];
      idx = idx+1;
      hasPreview = song.previewUrl != '';
    });
    initPlayer();
  }

  Future prev(Recommendation s) async {
    stop();
    setState(() {
      //play(s.prevSong);
      song = songData.tracks[idx-1];
      idx = idx-1;
      hasPreview = song.previewUrl != '';
    });
    initPlayer();
  }

  void _launchurl() async {
    var url = song.uri;

    try {
      await launchUrl(Uri.parse(url));
    } catch (err) {
      try {
        await launch('https://play.google.com/store/apps/details/?id=com.spotify.music&hl=el&gl=US');
      } catch (e) {
        throw 'e';
      }
    }
    // if (await canLaunch(url)) {    //canLaunch not working for some cases
    //   await launchUrl(Uri.parse(url));
    // } else if (await canLaunch('https://play.google.com/store/apps/details?id=com.spotify.music&hl=en_IN')) {
    //   await launch('https://play.google.com/store/apps/details?id=com.spotify.music&hl=en_IN');
    // } else {
    //   throw 'error';
    // }

  }

  Future mute(bool muted) async {
    if (muted) {
      await audioPlayer.setVolume(0.0);
    } else {
      await audioPlayer.setVolume(1.0);
    }
    setState(() {
      isMuted = muted;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildPlayer() => Container(
        padding: EdgeInsets.all(20.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Column(
            children: <Widget>[
              Text(
                song.name,
                style: Theme.of(context).textTheme.headline4,
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
          Row(mainAxisSize: MainAxisSize.min, children: [
          //   ControlButton(Icons.skip_previous, () => prev(widget.songData)),
            IconButton(icon: Icon(Icons.skip_previous), onPressed: idx > 0 ? () => prev(songData) : null),

            hasPreview ?
            Column(
              children: [
                IconButton(icon: isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                    onPressed: isPlaying ? () => pause() : () => play(song)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                        icon: isMuted
                            ? Icon(Icons.headset_off, color: Theme.of(context).unselectedWidgetColor)
                            : Icon(Icons.headset, color: Theme.of(context).unselectedWidgetColor),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          mute(!isMuted);
                        }),
                  ],
                )
              ],
            ) : Text('No preview \nis available', style: TextStyle(fontStyle: FontStyle.italic),),

            IconButton(icon: Icon(Icons.skip_next), onPressed: idx < 14 ? () => next(songData) : null),
          //   ControlButton(Icons.skip_next, () => next(widget.songData)),
          ]),

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
            padding: const EdgeInsets.only(bottom: 60.0),
          ),
          MaterialButton(child: Text("Listen the full track \non Spotify", style: Theme.of(context).textTheme.caption, textAlign: TextAlign.center,),
              onPressed: () { _launchurl(); })
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