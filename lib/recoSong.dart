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

    var pop = _mygenres[0];

    var mytoken = await auth.getAuthToken();
    // print(mytoken);

    final response = await http
        .get(Uri.parse('https://api.spotify.com/v1/recommendations?limit=15&market=GR&seed_genres=$pop&min_energy=$minE&max_energy=$maxE&min_valence=$minV&max_valence=$maxV'),
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

    // print('Artists:');
    // var artists = await spotify.artists.list(['5p7f24Rk5HkUZsaS3BLG5F']);
    // artists.forEach((x) => print(x.name));
    // https://open.spotify.com/artist/5p7f24Rk5HkUZsaS3BLG5F?si=yj8jJ9ubT7OgbnDOvg9JdA
    //
    // print('\nAlbum:');
    // var album = await spotify.albums.get('2Hog1V8mdTWKhCYqI5paph');
    // print(album.name);
    //
    // print('\nAlbum Tracks:');
    // var tracks = await spotify.albums.getTracks(album.id!).all();
    // tracks.forEach((track) {
    //   print(track.name);
    // });

    print('\n');
    print('\nRecommendations:');

    if(_myemotion == 'Happy' || _myemotion == 'Surprised') {
      mapMin = {'valence': 0.8, 'energy': 0.8};
      mapMax = {'valence': 1.0, 'energy': 1.0};
      mapT = {'valence': 1.0, 'energy': 1.0};
      print('happy');
    } else if(_myemotion == 'Sad' || _myemotion == 'Disgust') {
      mapMin = {'valence': 0.0, 'energy': 0.0};
      mapMax = {'valence': 0.4, 'energy': 0.4};
      mapT = {'valence': 0.2, 'energy': 0.2};
      print('sad');
    } else if(_myemotion == 'Angry' || _myemotion == 'Fear') {
      mapMin = {'valence': 0.0, 'energy': 0.6};
      mapMax = {'valence': 0.4, 'energy': 1.0};
      mapT = {'valence': 0.2, 'energy': 0.7};
      print('angry');
    } else if(_myemotion == 'Neutral') {
      mapMin = {'valence': 0.4, 'energy': 0.4};
      mapMax = {'valence': 0.6, 'energy': 0.6};
      mapT = {'valence': 0.5, 'energy': 0.5};
      print('neutral');
    }
    // recos = await spotify.recommendations.get(
    //   // seedArtists: [],
    //   seedGenres: ['pop'],
    //   // seedTracks: [],
    //   limit: 25,
    //   market: "GR",
    //   min: mapMin,
    //   max: mapMax,
    //   target: mapT
    // );

    var recos = await fetchRecos();
    print(recos);

    Map<String, dynamic> recoss = recos;
    recommendation = Recommendation.fromMap(recoss);

    setState(() {
      recommendation = recommendation;
    });

    recommendation.tracks.forEach((track) {
      print(track.name);
      print(" id: " + track.id);
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
        body:
          // Text("see results in your console!"),
        recommendation == null
            ? Center(child: CircularProgressIndicator())
            : Scrollbar(child: MyListView(songData: recommendation)),

    );
  }

}