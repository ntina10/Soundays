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
                var genreResults = get_selected();
                await Navigator.pushNamed(context, '/take_pic', arguments: genreResults);
              },
              child: Text("start emotion recognition")),
        ],
      ),
    );
  }
}