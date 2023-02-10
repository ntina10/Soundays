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
    {'id': 'alternative', 'value': 'Alternative', 'image': 'alter.png'},
    {'id': 'anime', 'value': 'Anime', 'image': 'anime.png'},
    {'id': 'blues', 'value': 'Blues', 'image': 'blues.png'},
    {'id': 'classical', 'value': 'Classical', 'image': 'class.png'},
    {'id': 'country', 'value': 'Country', 'image': 'country.png'},
    {'id': 'disco', 'value': 'Disco', 'image': 'disco.png'},
    {'id': 'disney', 'value': 'Disney', 'image': 'disney.png'},
    {'id': 'electronic', 'value': 'Electronic', 'image': 'electro.png'},
    {'id': 'folk', 'value': 'Folk', 'image': 'folk.png'},
    {'id': 'funk', 'value': 'Funk', 'image': 'funk.png'},
    {'id': 'heavy-metal', 'value': 'Heavy Metal', 'image': 'heavy.png'},
    {'id': 'hip-hop', 'value': 'Hip Hop', 'image': 'hiphop.png'},
    {'id': 'j-pop', 'value': 'j-pop', 'image': 'jpop.png'},
    {'id': 'j-rock', 'value': 'j-rock', 'image': 'jrock.png'},
    {'id': 'jazz', 'value': 'Jazz', 'image': 'jazz.png'},
    {'id': 'k-pop', 'value': 'k-pop', 'image': 'kpop.png'},
    {'id': 'metal', 'value': 'Metal', 'image': 'metal.png'},
    {'id': 'opera', 'value': 'Opera', 'image': 'opera.png'},
    {'id': 'pop', 'value': 'Pop', 'image': 'pop.png'},
    {'id': 'punk', 'value': 'Punk', 'image': 'punk.png'},
    {'id': 'r-n-b', 'value': 'RNB', 'image': 'rnb.png'},
    {'id': 'reggae', 'value': 'Reggae', 'image': 'reggae.png'},
    {'id': 'rock', 'value': 'Rock', 'image': 'rock.png'},
    {'id': 'soul', 'value': 'Soul', 'image': 'soul.png'}
  ];

  List<bool> selected = [];
  int counter = 0;

  List<int> indexes = [];

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
    indexes = List.generate(genres.length, (index) => index);
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
      // decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //         begin: Alignment.topCenter,
      //         end: Alignment.bottomCenter,
      //         // radius: 0.8,
      //         // center: Alignment.center,
      //         colors: [
      //           // Color.fromARGB(255, 255, 255, 255),
      //           // Color.fromARGB(255, 255, 205, 215),
      //           Color(0xFFB79DFF),
      //           Color(0xFFFFFFFF),
      //         ],
      //     )),
      child: Scaffold(
          backgroundColor: myBgColor,
          body:
          // AnimatedBackground(
          //   behaviour: RandomParticleBehaviour(options: particles),
          //   vsync: this,
          //   child:
            Stack(
                children: [
                  Column(
                    children: [
                      myTextTop(context, 'What makes your\nheart move?', 'Select up to 5'),
                      SizedBox(height: MediaQuery.of(context).size.height / 15,),
                      // Expanded(
                      //   child: Container(
                      //     child: _myListWidget()
                      //   ),
                      // ),
                      // Expanded(
                      //   child: Wrap(
                      //     spacing: 16,
                      //     runSpacing: 16,
                      //     // alignment: WrapAlignment.center,
                      //     children: [for (var i in indexes)
                      //       InkWell(
                      //           customBorder: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(20),
                      //           ),
                      //           onTap: () {
                      //             if (selected[i]) {
                      //               setState(() {
                      //                 selected[i] = false;
                      //                 counter -= 1;
                      //               });
                      //             } else {
                      //               if (counter < 5) {
                      //                 setState(() {
                      //                   selected[i] = true;
                      //                   counter += 1;
                      //                 });
                      //               }
                      //             }
                      //           },
                      //           child: Container(
                      //             // height: 50,
                      //             decoration: BoxDecoration(
                      //                 color: selected[i] ? Color(0xff5c5959) : Color(0xff272525),
                      //                 borderRadius: BorderRadius.circular(20)),
                      //             // margin: EdgeInsets.all(5),
                      //             // padding: EdgeInsets.all(16),
                      //             child: Column(children: [
                      //               ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset('assets/albums/' + genres[i]['image'].toString())),
                      //               Row(mainAxisSize: MainAxisSize.min,
                      //                 children: [
                      //                 Wrap(children: [ Text('hi')])
                      //               ],)
                      //             ])
                      //             // Column(
                      //             //   // crossAxisAlignment: CrossAxisAlignment.stretch,
                      //             //   children: [
                      //             //     // SizedBox(height: 16,),
                      //             //     Align(alignment: Alignment.centerLeft, child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset('assets/albums/' + genres[i]['image'].toString()))),
                      //             //     //SizedBox(height: 40,),
                      //             //     Row(
                      //             //       children: [
                      //             //         Text(
                      //             //           genres[i]['value'].toString(),
                      //             //           style: TextStyle(
                      //             //             fontWeight: FontWeight.w400,
                      //             //             fontFamily: "Poppins",
                      //             //             fontSize: 14,
                      //             //             color: Color(0xffb6b6b6),
                      //             //           ),
                      //             //         ),
                      //             //         if (selected[i]) Align(alignment: Alignment.centerRight, child: SvgPicture.asset('assets/selected.svg')),
                      //             //       ],
                      //             //     )
                      //             //   ],
                      //             // ),
                      //           ),
                      //         )
                      //       ],
                      //   )
                      // ),
                      Expanded(
                        child: GridView.builder(
                          // shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: genres.length,
                          itemBuilder: (ctx, i) {
                            return InkWell(
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onTap: () {
                                if (selected[i]) {
                                  setState(() {
                                    selected[i] = false;
                                    counter -= 1;
                                  });
                                } else {
                                  if (counter < 5) {
                                    setState(() {
                                      selected[i] = true;
                                      counter += 1;
                                    });
                                  }
                                }
                              },
                              child: Container(
                                // height: 50,
                                // width: 90,
                                decoration: BoxDecoration(
                                    color: selected[i] ? Color(0xff5c5959) : Color(0xff272525),
                                    borderRadius: BorderRadius.circular(20)),
                                // margin: EdgeInsets.all(5),
                                // padding: EdgeInsets.all(16),
                                child:
                                Column(
                                  // mainAxisSize: MainAxisSize.min,
                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    // SizedBox(height: 16,),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: ClipRRect(borderRadius: BorderRadius.circular(10), child: SizedBox(width: 140, child: Image.asset('assets/photo-1507832321772-e86cc0452e9c.jpg' ))), //+ genres[i]['image'].toString()
                                    ),
                                    //SizedBox(height: 40,),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0), //const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Row(
                                        // mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            genres[i]['value'].toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Poppins",
                                              fontSize: 14,
                                              color: Color(0xffb6b6b6),
                                            ),
                                          ),
                                          if (selected[i]) Expanded(child: Align(alignment: Alignment.centerRight, child: SvgPicture.asset('assets/checkbox.svg'))),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.05,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            // mainAxisExtent: 264,
                          ),
                        ),
                      ),
                      // SizedBox(height: 16,)
                    ],
                  ),

                  // Positioned(
                  //   bottom: 60,
                  //   left: 145,
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 15),
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

