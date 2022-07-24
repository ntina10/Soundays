import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:spotify/spotify.dart';
import 'package:test_zero/my_listview.dart';
import 'package:http/http.dart' as http;
import 'package:test_zero/auth_spotify.dart';

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

  //var recos;
  var recommendation;

  @override
  void initState() {
    _myemotion = widget.myemotion;
    _mygenres = widget.mygenres;

    // credentials = SpotifyApiCredentials("ea02e1bbc577462bbb9d9baa73c55151", "9b895619bd414c1eae753515e45f2561");
    // spotify = SpotifyApi(credentials);

    doMagic();
    super.initState();
  }

  Future<dynamic> fetchRecos() async {
    var minE = mapMin['energy'];
    var minV = mapMin['valence'];
    var maxE = mapMax['energy'];
    var maxV = mapMax['valence'];

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
        .get(Uri.parse('https://api.spotify.com/v1/recommendations?limit=15&market=GR&seed_genres=$glist&min_energy=$minE&max_energy=$maxE&min_valence=$minV&max_valence=$maxV'),
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

    if(_myemotion == 'happiness' || _myemotion == 'surprise') {
      mapMin = {'valence': 0.7, 'energy': 0.7};
      mapMax = {'valence': 1.0, 'energy': 1.0};
      mapT = {'valence': 0.8, 'energy': 0.8};
      print('happy');
    } else if(_myemotion == 'sadness' || _myemotion == 'disgust') {
      mapMin = {'valence': 0.0, 'energy': 0.0};
      mapMax = {'valence': 0.4, 'energy': 0.4};
      mapT = {'valence': 0.2, 'energy': 0.2};
      print('sad');
    } else if(_myemotion == 'anger' || _myemotion == 'fear') {
      mapMin = {'valence': 0.0, 'energy': 0.6};
      mapMax = {'valence': 0.4, 'energy': 1.0};
      mapT = {'valence': 0.2, 'energy': 0.7};
      print('angry');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[300],
        appBar: AppBar(
          title: Text('Your $_myemotion Playlist'),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          elevation: 5.0,
        ),
        body: recommendation == null
            ? Center(child: CircularProgressIndicator())
            : Scrollbar(child: MyListView(songData: recommendation)),

    );
  }

}