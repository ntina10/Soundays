import 'dart:convert';
import 'package:flutter/material.dart';
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
    // print(mytoken);

    final response = await http
        .get(Uri.parse('https://api.spotify.com/v1/recommendations?limit=15&market=GR&seed_genres=$glist&min_energy=$minE&max_energy=$maxE&target_energy=$tE&min_valence=$minV&max_valence=$maxV&target_valence=$tV'),
            headers: {
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
      throw Exception('Failed to load recommendations');
    }
  }

  Future<void> doMagic() async {
    print('Recommendations:');

    if(_myemotion == 'happiness') {
      mapMin = {'valence': 0.7, 'energy': 0.7};
      mapMax = {'valence': 1.0, 'energy': 0.9};
      mapT = {'valence': 0.8, 'energy': 0.8};
      print('happy');
    } else if( _myemotion == 'surprise') {
      mapMin = {'valence': 0.6, 'energy': 0.9};
      mapMax = {'valence': 0.8, 'energy': 1.0};
      mapT = {'valence': 0.7, 'energy': 0.95};
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
      mapMin = {'valence': 0.0, 'energy': 0.7};
      mapMax = {'valence': 0.5, 'energy': 1.0};
      mapT = {'valence': 0.3, 'energy': 0.9};
      print('angry');
    } else if(_myemotion == 'fear') {
      mapMin = {'valence': 0.0, 'energy': 0.8};
      mapMax = {'valence': 0.4, 'energy': 1.0};
      mapT = {'valence': 0.3, 'energy': 0.95};
      print('fear');
    } else if(_myemotion == 'neutral') {
      mapMin = {'valence': 0.4, 'energy': 0.4};
      mapMax = {'valence': 0.6, 'energy': 0.6};
      mapT = {'valence': 0.5, 'energy': 0.5};
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

  Future<bool> _onWillPop() async {
    Navigator.of(context)
        .popUntil(ModalRoute.withName("/genres"));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: Colors.green[300],
          appBar: AppBar(
            title: Text('Your $_myemotion Playlist'),
            backgroundColor: Colors.green[800],
            elevation: 5.0,
              actions: <Widget> [
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        //Navigator.pushReplacementNamed(context, "/home");
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: Icon(
                        Icons.home,
                        size: 26.0,
                      ),
                    )
                )
              ]
          ),
          body: recommendation == null
              ? Center(child: CircularProgressIndicator())
              : Scrollbar(child: MyListView(songData: recommendation)),

      ),
    );
  }

}