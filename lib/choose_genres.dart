import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soundays/myElements.dart';
import 'package:soundays/pre_picture.dart';
import 'package:animated_background/animated_background.dart';
import 'package:soundays/bg_color.dart';

class ChooseGenres extends StatefulWidget {
  const ChooseGenres({Key? key}) : super(key: key);

  @override
  _ChooseGenresState createState() => _ChooseGenresState();
}

class _ChooseGenresState extends State<ChooseGenres> {
  var genres = [
    {'id': 'alternative', 'value': 'Alternative'},
    {'id': 'anime', 'value': 'Anime'},
    {'id': 'blues', 'value': 'Blues'},
    {'id': 'classical', 'value': 'Classical'},
    {'id': 'country', 'value': 'Country'},
    {'id': 'disco', 'value': 'Disco'},
    {'id': 'disney', 'value': 'Disney'},
    {'id': 'electronic', 'value': 'Electronic'},
    {'id': 'folk', 'value': 'Folk'},
    {'id': 'funk', 'value': 'Funk'},
    {'id': 'heavy-metal', 'value': 'Heavy Metal'},
    {'id': 'hip-hop', 'value': 'Hip Hop'},
    {'id': 'j-pop', 'value': 'j-pop'},
    {'id': 'j-rock', 'value': 'j-rock'},
    {'id': 'jazz', 'value': 'Jazz'},
    {'id': 'k-pop', 'value': 'k-pop'},
    {'id': 'metal', 'value': 'Metal'},
    {'id': 'opera', 'value': 'Opera'},
    {'id': 'pop', 'value': 'Pop'},
    {'id': 'punk', 'value': 'Punk'},
    {'id': 'r-n-b', 'value': 'RNB'},
    {'id': 'reggae', 'value': 'Reggae'},
    {'id': 'rock', 'value': 'Rock'},
    {'id': 'soul', 'value': 'Soul'}
  ];

  List<bool> selected = [];
  int counter = 0;

  // ParticleOptions particles = const ParticleOptions(
  //   //baseColor: Colors.cyan,
  //   spawnOpacity: 0.8,
  //   opacityChangeRate: 0.25,
  //   minOpacity: 1.0,
  //   maxOpacity: 1.0,
  //   particleCount: 4,
  //   spawnMaxRadius: 150.0,
  //   spawnMaxSpeed: 50.0,
  //   spawnMinSpeed: 30,
  //   spawnMinRadius: 150.0,
  //   image: Image(image: AssetImage('assets/bubble1.png'),),
  // );

  List<String> get_selected() {
    List<String> ans = [];
    for(var i =0; i<genres.length; i++) {
      if(selected[i] == true) {
          ans.add(genres[i]['id'] ?? '');
      }
    }
    return ans;
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < genres.length; i++) {
      selected.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // radius: 0.8,
              // center: Alignment.center,
              colors: [
                // Color.fromARGB(255, 255, 255, 255),
                // Color.fromARGB(255, 255, 205, 215),
                Color(0xFFB79DFF),
                Color(0xFFFFFFFF),
              ],
          )),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body:
          // AnimatedBackground(
          //   behaviour: RandomParticleBehaviour(options: particles),
          //   vsync: this,
          //   child:
            Stack(
                children: [
                  Column(
                    children: [
                      myTextTop('What makes your\nheart move?', 'Select up to 5'),
                      SizedBox(height: 24,),
                      Expanded(
                        child: Container(
                          child: _myListWidget()
                        ),
                      ),
                    ],
                  ),
                  // Positioned(
                  //   bottom: 60,
                  //   left: 145,
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 90.0),
                        child: myButton((counter < 1) ? null : () async {
                                        var genreResults = get_selected();
                                        await Navigator.pushNamed(context, '/pre_pic', arguments: genreResults);
                                      }, 'Next'),
                      ),
                    ),
                  //),
                ],
              ),
          //),
      ),
      );
  }

  Widget _myListWidget() {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        //scrollDirection: Axis.vertical,
        //physics: AlwaysScrollableScrollPhysics(),
        itemCount: genres.length,
        itemBuilder: (ctx, index) => InkWell(
          onTap: () {
            if (selected[index]) {
              setState(() {
                selected[index] = false;
                counter -= 1;
              });
            } else {
              if (counter < 5) {
                setState(() {
                  selected[index] = true;
                  counter += 1;
                });
              }
            }
          },
          child:
          Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                //alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: selected[index] ? Colors.white : Colors.transparent,
                    border: Border.all(
                        color: Colors.white
                      // color: selected[index]
                      //     ? Colors.transparent
                      //     : Colors.black26
                    ),
                    borderRadius: BorderRadius.circular(100.0)),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                        child:
                        Text(
                          genres[index]['value'].toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins",
                              fontSize: 16,
                              height: 1.5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: selected[index] ? SizedBox(height: 16,child: SvgPicture.asset('assets/selected.svg')) : SizedBox(height: 16,child: SvgPicture.asset('assets/default.svg'))//Icon(Icons.check_circle_outline, size: 16,) : Icon(Icons.radio_button_unchecked, size: 16,),
                    )
                  ],
                ),
              ),
              if (index == genres.length - 1) SizedBox(height: 120,)
            ],
          ),
        )
    );

  }

}

