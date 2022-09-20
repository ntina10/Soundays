import 'package:flutter/material.dart';
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
    'surpise': 'surprised',
    'anger': 'angry',
    'disgust': 'disgust',
    'fear': 'fear',
    'happiness': 'happy',
    'sadness': 'sad',
    'neutral': 'neutral'
  };
  Map colorMap = {
    'surpise': Color(0xFFFCD06A),
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
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              colorMap[emotion],
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
              SizedBox(height: 180,),
              Container(width: 200, height: 200, child: Image.asset('assets/' + emotionMap[emotion] + '.png')),
              SizedBox(height: 20,),
              Text('Feeling\n' + emotionMap[emotion], textAlign: TextAlign.center, style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, fontFamily: "Poppins",)),
              SizedBox(height: 50,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black, shape: StadiumBorder()),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecoSong(myemotion: emotion, mygenres: genres),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 15.0),
                    child: Text("Show me the music!", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Poppins")),
                  )
              ),
            ],
          ),
        )
      ),
    );
  }

}
