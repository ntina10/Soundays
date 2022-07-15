import 'package:flutter/material.dart';

class ChooseGenres extends StatefulWidget {
  const ChooseGenres({Key? key}) : super(key: key);

  @override
  _ChooseGenresState createState() => _ChooseGenresState();
}

class _ChooseGenresState extends State<ChooseGenres> {
  var genres = [
    {'alternative': 'Alternative'},
    {'anime': 'Anime'},
    {'blues': 'Blues'},
    {'classical' : 'Classical'},
    {'country': 'Country'},
    {'disco': 'Disco'},
    {'disney': 'Disney'},
    {'electronic': 'Electronic'},
    {'folk': 'Folk'},
    {'funk': 'Funk'},
    {'heavy-metal': 'Heavy Metal'},
    {'hip-hop': 'Hip Hop'},
    {'j-pop': 'j-pop'},
    {'j-rock': 'j-rock'},
    {'jazz': 'Jazz'},
    {'k-pop': 'k-pop'},
    {'metal': 'Metal'},
    {'opera': 'Opera'},
    {'pop': 'Pop'},
    {'punk': 'Punk'},
    {'r-n-b': 'RNB'},
    {'reggae': 'Reggae'},
    {'rock': 'Rock'},
    {'soul': 'Soul'}
  ];

  List<bool> selected = [];
  int counter = 0;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < genres.length; i++) {
      selected.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose up to 5 genres'),
        centerTitle: true,
        backgroundColor: Colors.green[800],
        elevation: 5.0,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            //color: Colors.red,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
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
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: selected[index] ? Colors.lightBlueAccent : Colors.transparent,
                        border: Border.all(
                            color: selected[index]
                                ? Colors.transparent
                                : Colors.black26),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      genres[index].values.toString(),
                      style: TextStyle(
                          color: selected[index]
                              ? Colors.white
                              : Colors.blue.withOpacity(0.8),
                          fontSize: 15),
                    ),
                  ),
                )
            ),
          ),
          ElevatedButton(
              style: (counter < 1) ? ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey)
              ) : null,
              onPressed: (counter < 1) ? null : () async {
                await Navigator.pushNamed(context, '/camera');
              },
              child: Text("start emotion recognition")),
        ],
      ),
    );
  }
}