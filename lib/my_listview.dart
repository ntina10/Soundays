import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soundays/models/recommendations.dart';
import 'package:soundays/models/track.dart';
import 'package:soundays/myElements.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:soundays/alert_rating.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyListView extends StatefulWidget {
  final Recommendation songData;
  final String emotion;
  //final List<MaterialColor> _colors = Colors.primaries;

  const MyListView({required this.songData, required this.emotion});

  @override
  _MyListViewState createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {

  late List<int> values;

  late Recommendation songData;
  late String myemotion;

  int selectedIndex = -1;

  Map colorMap = {
    'surprise': Color(0xFFFCD06A),
    'anger': Color(0xFFFCBBD7),
    'disgust': Color(0xFF99FF8A),
    'fear': Color(0xFFA9CFEA),
    'happiness': Color(0xFFFCD06A),
    'sadness': Color(0xFFA9CFEA),
    'neutral': Color(0xFFFCD06A)
  };

  AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration(seconds: 20);
  late Duration position;

  get isPlaying => audioPlayer.state == PlayerState.playing;
  get isPaused => audioPlayer.state == PlayerState.paused;

  List<bool> audiostatus = [];

  @override
  void initState() {
    songData = widget.songData;
    myemotion = widget.emotion;
    for(var i = 0; i<songData.tracks.length; i++) {
      audiostatus.add(false);
    }
    //hasPreview = song.previewUrl != '';
    initPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
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
      setState(() => duration = d);
    });

    audioPlayer.onPositionChanged.listen((positionValue) {
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

  void _launchurl() async {
    var myuri = songData.tracks[selectedIndex].uri;
    try {
      await launchUrl(Uri.parse(myuri));
    } catch (err) {
      try {
        await launch('https://play.google.com/store/apps/details/?id=com.spotify.music&hl=el&gl=US');
      } catch (e) {
        throw 'e';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: songData.tracks.length,
          itemBuilder: (context, int index) {
            var s = songData.tracks[index];
            //var myindex = index;
            //final MaterialColor color = _colors[index % _colors.length];
            var album_pic = s.album.images[0].url;
            //s.albumArt == null ? null : File.fromUri(Uri.parse(s.albumArt));

            return Column(
              children: [
                Card(
                  elevation: 0.0,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                    dense: false,
                    leading: CircleAvatar(
                      //AssetImage('no_album.png'),
                      backgroundImage: album_pic == null ? NetworkImage('https://i.scdn.co/image/ab67616d0000b273c5015d2a9270865a5979f56b')
                                                         : NetworkImage(album_pic), //AssetImage('assets/some_album.jpg'),
                      radius: 28.0,
                    ),
                    title: Text(s.name, style: TextStyle(fontSize: 14.0, fontFamily: "Poppins",)) ,
                    subtitle: Text("By ${s.artists[0].name}", style: TextStyle(fontSize: 14.0, fontFamily: "Poppins", color: Color(0xFFB1B1B1))),
                    tileColor: selectedIndex == index ? Color(0xFFE5E5E5) : null,
                    onTap: () {
                      selectedIndex == index ?
                      setState(() {
                        selectedIndex = -1;
                      })
                      :
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    trailing: s.previewUrl != '' ?
                    Stack(
                      children: [
                        Positioned(
                          top: 12,
                          right: 12,
                          child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator(value: audiostatus[index] ? position.inSeconds/duration.inSeconds : 0.0, strokeWidth: 2, backgroundColor: Color(0xFFE5E5E5), color: Colors.green,))
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
                                                            selectedIndex = index;
                                                            position = new Duration();
                                                            audiostatus[index] = true;
                                                        });
                                              }
                                    ),
                      ],
                    )
                    : null
                  ),
                ),
                if (index == songData.tracks.length - 1) SizedBox(height: MediaQuery.of(context).size.height / 6.7,)
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Divider(
                height: 1,
                color: Color(0xFFE5E5E5),
              ),
            );
          },
        ),
        Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black,),
                      child: MaterialButton(onPressed: () {Navigator.popUntil(context, (route) => route.isFirst);},
                        child: Icon(Icons.home_rounded, color: colorMap[myemotion], size: 24,),
                      ),
                    ),
                    SizedBox(width: 8,),
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black,),
                      child: MaterialButton(onPressed: () {showAlertDialog(context, myemotion);},
                        child: Container(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset('assets/star_full.svg'),
                        ),
                      ),
                    ),
                    SizedBox(width: 8,),
                    myButtonWithChild(
                      selectedIndex != -1 ? () { _launchurl(); } : null,
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text('Listen on', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins')),
                          ),
                          SizedBox(
                            height: 20,
                            child: Image.asset('assets/spotify_logo.png'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 90,)
          ],
        ),
      ],
    );
  }
}

class AudioFile {
  String url;
  bool playingstatus;

  AudioFile({required this.url, required this.playingstatus});
}