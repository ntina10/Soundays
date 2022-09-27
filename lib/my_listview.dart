import 'package:flutter/material.dart';
import 'package:soundays/models/recommendations.dart';
import 'package:soundays/models/track.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soundays/request.dart';
import 'package:soundays/globals.dart' as globals;

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
          padding: EdgeInsets.zero,
          itemCount: songData.tracks.length,
          itemBuilder: (context, int index) {
            var s = songData.tracks[index];
            //var myindex = index;
            //final MaterialColor color = _colors[index % _colors.length];
            var album_pic = s.album.images[0].url;
            //s.albumArt == null ? null : File.fromUri(Uri.parse(s.albumArt));

            return Card(
              elevation: 0.0,
              child: ListTile(
                dense: false,
                leading: CircleAvatar(
                  //AssetImage('no_album.png'),
                  backgroundImage: album_pic == null ? NetworkImage('https://i.scdn.co/image/ab67616d0000b273c5015d2a9270865a5979f56b')
                                                     : NetworkImage(album_pic), //AssetImage('assets/some_album.jpg'),
                  radius: 28.0,
                ),
                title: Text(s.name, style: TextStyle(fontSize: 14.0, fontFamily: "Poppins",)) ,
                subtitle: Text("By ${s.artists[0].name}", style: TextStyle(fontSize: 14.0, fontFamily: "Poppins", color: Color(0xFFB1B1B1))),
                tileColor: selectedIndex == index ? Colors.yellow[100] : null,
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
                      top: 9,
                        right: 9,
                        child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator(value: audiostatus[index] ? position.inSeconds/duration.inSeconds : 0.0, strokeWidth: 2, backgroundColor: Colors.grey, color: Colors.green,))
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
        ),
        Padding(
          padding: const EdgeInsets.only(top: 420.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 56,
                  width: 56,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black,),
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.star_rate_rounded,),
                      color: Color(0xFFF9DB6F),
                      iconSize: 40,
                      onPressed: () {showAlertDialog(context, myemotion);},
                    ),
                  )
              ),
              SizedBox(width: 8,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black, shape: StadiumBorder()),
                  onPressed: selectedIndex != -1 ?
                      () { _launchurl(); } : null,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Text("Listen on", style: TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                        SizedBox(
                          height: 25,
                          child: Image.asset('assets/spotify_logo.png'),
                        )
                      ],
                    ),
                  )
              ),
            ],
          ),
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

showAlertDialog(BuildContext context, String myemotion) {

  late double myrating;

  // set up the button
  Widget noButton = FlatButton(
    child: Text("I'll do it later", style: TextStyle(fontSize: 16.0, fontFamily: "Poppins", color: Color(0xFFA3A2A2))),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget okayButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.black, shape: StadiumBorder()),
      onPressed: () async {
        //do the saving of rating
        print('Saving rating');
        var url = Uri.parse(globals.apiAddress + '/rating');
        var data = await setRate(myemotion, myrating, url);
        print('Response of rating is ${data.toString()}');
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        child: Text("Submit!", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Poppins")),
      )
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          // title: Text("It works!"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          content: Container(
            height: 350,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text('Are you feeling it?', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins",),),
                SizedBox(height: 10,),
                Text('Please rate your playlist',
                  style: TextStyle(fontSize: 16.0, fontFamily: "Poppins",),),
                SizedBox(height: 50,),
                //stars
                RatingBar(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  // itemBuilder: (context, _) => {}
                  ratingWidget: RatingWidget(
                      full: SvgPicture.asset('assets/star_full.svg'),//Icon(Icons.star_rounded, color: Color(0xFFF9DB6F),),
                      half: SvgPicture.asset('assets/star_full.svg'),
                      empty: SvgPicture.asset('assets/star_empty.svg'),//Image.asset('assets/star_empty.svg'),
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      myrating = rating;
                    });
                    print(myrating);
                  },
                ),
                SizedBox(height: 50,),
                okayButton,
                SizedBox(height: 10,),
                noButton,
              ],
            ),
          ),
          // actions: [
          //   okayButton,
          // ],
        );
      });
    },
  );
}