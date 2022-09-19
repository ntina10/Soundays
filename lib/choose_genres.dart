import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return Container(
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
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 50,),
                Text('What makes your\nheart move?', textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, fontFamily: "Poppins",),),
                SizedBox(height: 20,),
                Text('Select up to 5', style: TextStyle(fontSize: 16.0, fontFamily: "Poppins",),),
                SizedBox(height: 10,),
                Expanded(
                  child: Container(
                    child: _myListWidget()
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 60,
              left: 145,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: (counter < 1) ? Colors.grey : Colors.black, shape: StadiumBorder()),
                onPressed: (counter < 1) ? null : () async {
                  var genreResults = get_selected();
                  await Navigator.pushNamed(context, '/take_pic', arguments: genreResults);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 15.0),
                  child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 18)),
                )
              ),
            ),
          ],
        ),
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
          child: index == genres.length - 1 ? _lastElement(index) :
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
                borderRadius: BorderRadius.circular(28.0)),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      genres[index]['value'].toString(),
                      style: TextStyle(
                        // color: selected[index]
                        //     ? Colors.white
                        //     : Colors.blue.withOpacity(0.8),
                          fontFamily: "Poppins",
                          fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: selected[index] ? Icon(Icons.check_circle_outline, size: 16,) : Icon(Icons.radio_button_unchecked, size: 16,),
                )
              ],
            ),
          ),
        )
    );

  }

  Widget _lastElement(index) {
    return Column(
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
              borderRadius: BorderRadius.circular(28.0)),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    genres[index]['value'].toString(),
                    style: TextStyle(
                      // color: selected[index]
                      //     ? Colors.white
                      //     : Colors.blue.withOpacity(0.8),
                        fontFamily: "Poppins",
                        fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: selected[index] ? Icon(Icons.check_circle_outline, size: 16,) : Icon(Icons.radio_button_unchecked, size: 16,),
              )
            ],
          ),
        ),
        SizedBox(height: 120,),
      ],
    );
  }
}

