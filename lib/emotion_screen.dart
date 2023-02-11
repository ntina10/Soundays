import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soundays/alert_emotions.dart';
import 'package:soundays/bg_color.dart';
import 'package:soundays/botNavBar.dart';
import 'package:soundays/myElements.dart';
import 'package:soundays/recoSong.dart';

class EmotionScreen extends StatefulWidget {
  final Map myEmotions;
  final List<String> myGenres;

  const EmotionScreen({required this.myEmotions, required this.myGenres});

  @override
  _EmotionScreenState createState() => _EmotionScreenState();
}

class _EmotionScreenState extends State<EmotionScreen> {
  late final Map emotions;
  late final List<String> genres;
  late final String emotion;

  Map emotionMap = {
    'surprise': 'surprised',
    'anger': 'angry',
    'disgust': 'disgust',
    'fear': 'fear',
    'happiness': 'happy',
    'sadness': 'sad',
    'neutral': 'neutral'
  };
  Map colorMap = {
    // 'surprise': Color(0xFFFCD06A),
    // 'anger': Color(0xFFFCBBD7),
    // 'disgust': Color(0xFF99FF8A),
    // 'fear': Color(0xFFA9CFEA),
    // 'happiness': Color(0xFFFCD06A),
    // 'sadness': Color(0xFFA9CFEA),
    // 'neutral': Color(0xFFFCD06A)
    'surprise': Color(0xFFC57DE2),
    'anger': Color(0xFFF9907F),
    'disgust': Color(0xFFABE79C),
    'fear': Color(0xFF8E74F9),
    'happiness': Color(0xFFFAD983),
    'sadness': Color(0xFF9CE4FF),
    'neutral': Color(0xFFF6F7FF)
  };

  @override
  void initState() {
    super.initState();
    emotions = widget.myEmotions;
    emotion = emotions.keys.first;
    genres = widget.myGenres;

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: RadialGradient(
            // begin: Alignment.centerLeft,
            // end: Alignment.centerRight,
            radius: 0.77,
            //focal: Alignment(0.3, -0.1),
            center: Alignment(0.0, -0.5),
            colors: [
              //colorMap[emotion],
              // Color(0xFFFFFFFF),
              myColorMap[emotion],
              //Color(0xFFBD00FF),
              myBgColor,

            ],
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        //bottomNavigationBar: BotNavBar(mygenres: genres,),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 16.7,),
              Container(width: 280, height: MediaQuery.of(context).size.height / 2.7, child: Image.asset('assets/' + emotionMap[emotion] + '.png')),
              SizedBox(height: MediaQuery.of(context).size.height / 20,),
              Text('Feeling\n' + emotionMap[emotion] + '!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 32.0, fontWeight: FontWeight.bold, fontFamily: "Satoshi", height: 1.125)),
              SizedBox(height: MediaQuery.of(context).size.height / 20,),
              myButton(() {
                Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecoSong(myemotion: emotion, mygenres: genres),
                                ),
                              );
              }, 'Show me the music!'),
              SizedBox(height: MediaQuery.of(context).size.height / 16,),
              MaterialButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: SvgPicture.asset('assets/selected.svg'),
                      ),
                    ),
                    SizedBox(width: 16,),
                    Text('Show me full results', style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: "Poppins",
                      color: Colors.white,
                      // shadows: [Shadow(color: Colors.black, offset: Offset(0, -3))],
                      // color: Colors.transparent,
                      // decorationColor: Colors.black,
                      // decoration: TextDecoration.underline,
                    ),
                    ),
                  ],
                ),
                onPressed: () {
                  showAlertDialogEmo(context, emotions);
                },
              ),
            ],
          ),
        )
      ),
    );
  }

}
