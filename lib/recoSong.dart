import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soundays/botNavBar.dart';
import 'package:soundays/myElements.dart';
import 'package:soundays/my_listview.dart';
import 'package:http/http.dart' as http;
import 'package:soundays/auth_spotify.dart';

import 'models/recommendations.dart';

class RecoSong extends StatefulWidget {
  final String myemotion;
  final List<String> mygenres;

  const RecoSong({required this.myemotion, required this.mygenres});

  @override
  _RecoSongState createState() => _RecoSongState();

}

class _RecoSongState extends State<RecoSong> {
  late final String _myemotion;
  late final List<String> _mygenres;

  Map<String, num> mapMin = {'valence': 0.5, 'energy': 0.5};
  Map<String, num> mapMax = {'valence': 0.5, 'energy': 0.5};
  Map<String, num> mapT = {'valence': 0.5, 'energy': 0.5};

  final Authentication auth = new Authentication();
  var recommendation;

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
    _myemotion = widget.myemotion;
    _mygenres = widget.mygenres;

    doMagic();
    super.initState();
  }

  Future<dynamic> fetchRecos() async {
    var minE = mapMin['energy'];
    var minV = mapMin['valence'];
    var maxE = mapMax['energy'];
    var maxV = mapMax['valence'];
    // var minA = mapMin['myVal'];
    // var maxA = mapMax['myVal'];
    var tE = mapT['energy'];
    var tV = mapT['valence'];
    // var tA = mapT['myVal'];

    String seed_generator(List<String> mylist) {
      String result = mylist[0];
      for (var i=1; i<mylist.length; i++) {
        result = result + '%2C' + mylist[i];
      }
      return result;
    }

    var glist = seed_generator(_mygenres);

    var mytoken = await auth.getAuthToken();

    final response = await http
        .get(Uri.parse('https://api.spotify.com/v1/recommendations?limit=25&seed_genres=$glist&min_energy=$minE&max_energy=$maxE&target_energy=$tE&min_valence=$minV&max_valence=$maxV&target_valence=$tV'),
            headers: {                                                      //&market=GR
              "Accept": "application/json",
              "Content-Type": "application/json",
              "Authorization": "Bearer $mytoken"
            }
        );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('Exception thrown in '+ response.statusCode.toString());
      throw Exception('Failed to load recommendations');
    }
  }

  Future<void> doMagic() async {
    print('Recommendations:');

    if(_myemotion == 'happiness') {
      mapMin = {'valence': 0.7, 'energy': 0.7, 'myVal': 0.0}; //add acoustic features if needed
      mapMax = {'valence': 1.0, 'energy': 0.9, 'myVal': 0.5};
      mapT = {'valence': 0.8, 'energy': 0.8, 'myVal': 0.25};
      print('happy');
    } else if( _myemotion == 'surprise') {
      mapMin = {'valence': 0.6, 'energy': 0.9, 'myVal': 0.0};
      mapMax = {'valence': 0.8, 'energy': 1.0, 'myVal': 0.5};
      mapT = {'valence': 0.7, 'energy': 0.95, 'myVal': 0.25};
      print('surprise');
    } else if(_myemotion == 'sadness') {
      mapMin = {'valence': 0.0, 'energy': 0.0};
      mapMax = {'valence': 0.3, 'energy': 0.4};
      mapT = {'valence': 0.2, 'energy': 0.2};
      print('sad');
    } else if(_myemotion == 'disgust') {
      mapMin = {'valence': 0.0, 'energy': 0.6};
      mapMax = {'valence': 0.2, 'energy': 0.8};
      mapT = {'valence': 0.1, 'energy': 0.7};
      print('disgust');
    } else if(_myemotion == 'anger') {
      mapMin = {'valence': 0.0, 'energy': 0.7, 'myVal': 0.0};
      mapMax = {'valence': 0.5, 'energy': 1.0, 'myVal': 0.5};
      mapT = {'valence': 0.3, 'energy': 0.9, 'myVal': 0.25};
      print('angry');
    } else if(_myemotion == 'fear') {
      mapMin = {'valence': 0.0, 'energy': 0.8, 'myVal': 0.0};
      mapMax = {'valence': 0.4, 'energy': 1.0, 'myVal': 0.5};
      mapT = {'valence': 0.3, 'energy': 0.95, 'myVal': 0.25};
      print('fear');
    } else if(_myemotion == 'neutral') {
      mapMin = {'valence': 0.4, 'energy': 0.4, 'myVal': 0.4};
      mapMax = {'valence': 0.6, 'energy': 0.6, 'myVal': 0.6};
      mapT = {'valence': 0.5, 'energy': 0.5, 'myVal' : 0.5};
      print('neutral');
    }

    var recos = await fetchRecos();
    print(recos);

    Map<String, dynamic> recoss = recos;
    recommendation = Recommendation.fromMap(recoss);

    setState(() {
      recommendation = recommendation;
    });

    //////////////debug printing
    recommendation.tracks.forEach((track) {
      print(track.name);
      print(" id: " + track.id);
    });
    recommendation.seeds.forEach((seed) {
      print(" id: " + seed.id);
    });

  }

  // Future<bool> _onWillPop() async {
  //   Navigator.of(context)
  //       .popUntil(ModalRoute.withName("/genres"));
  //   return false;
  // }
  // WillPopScope(
  // onWillPop: _onWillPop,
  // child: Scaffold())

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        extendBody: true,
        bottomNavigationBar: BotNavBar(mygenres: _mygenres,),
        //               Navigator.popUntil(context, (route) => route.isFirst);
        //             },
        //             child: Icon(
        //               Icons.home,
        //               size: 26.0,

        body: Center(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: 1.0,
                    center: Alignment(0.0, -0.20),
                    colors: [
                      Color(0xFFFFFFFF),
                      colorMap[_myemotion]
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 70,),
                    Container(width: 90, height: 90, child: Image.asset('assets/' + emotionMap[_myemotion] + '.png')),
                    SizedBox(height: 10,),
                    myTitle('Feeling\n' + emotionMap[_myemotion] + '!'),
                    SizedBox(height: 30,),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
              //   child: Divider(
              //     height: 10,
              //     color: Colors.grey[800],
              //   ),
              // ),
              SizedBox(height: 16,),
              recommendation == null
                  ? Center(child: Column(
                      children: const [
                        SizedBox(height: 100,),
                        Text("We are generating\nyour playlist", textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontFamily: "Poppins",)),
                        SizedBox(height: 40,),
                        CircularProgressIndicator(),
                      ],
                    ))
                  : Expanded(
                      child: Scrollbar(child: MyListView(songData: recommendation, emotion: _myemotion))
                    ),
            ],
          ),
        ),
    );
  }

}