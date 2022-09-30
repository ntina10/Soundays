import 'package:flutter/material.dart';
import 'package:soundays/myElements.dart';
import 'package:soundays/recoSong.dart';

class EmotionScreen extends StatefulWidget {
  final String myEmotion;
  final List<String> myGenres;

  const EmotionScreen({required this.myEmotion, required this.myGenres});

  @override
  _EmotionScreenState createState() => _EmotionScreenState();
}

class _EmotionScreenState extends State<EmotionScreen> {
  late final String emotion;
  late final List<String> genres;

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
    'surprise': Color(0xFFFCD06A),
    'anger': Color(0xFFFCBBD7),
    'disgust': Color(0xFF99FF8A),
    'fear': Color(0xFFA9CFEA),
    'happiness': Color(0xFFFCD06A),
    'sadness': Color(0xFFA9CFEA),
    'neutral': Color(0xFFFCD06A)
  };

  @override
  void initState() {
    super.initState();
    emotion = widget.myEmotion;
    genres = widget.myGenres;

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: RadialGradient(
            // begin: Alignment.centerLeft,
            // end: Alignment.centerRight,
            radius: 1.0,
            //focal: Alignment(0.3, -0.1),
            center: Alignment(0.0, -0.35),
            colors: [
              //colorMap[emotion],
              Color(0xFFFFFFFF),
              colorMap[emotion]
            ],
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 170,),
              Container(width: 220, height: 220, child: Image.asset('assets/' + emotionMap[emotion] + '.png')),
              SizedBox(height: 40,),
              Text('Feeling\n' + emotionMap[emotion] + '!', textAlign: TextAlign.center, style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, fontFamily: "Poppins", height: 1.01)),
              SizedBox(height: 40,),
              myButton(() {
                Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecoSong(myemotion: emotion, mygenres: genres),
                                ),
                              );
              }, 'Show me the music!'),
            ],
          ),
        )
      ),
    );
  }

}
