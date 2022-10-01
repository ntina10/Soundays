import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soundays/myElements.dart';
import 'package:soundays/request.dart';
import 'package:soundays/globals.dart' as globals;

showAlertDialog(BuildContext context, String myemotion) {

  late double myrating;

  // set up the button
  Widget noButton = FlatButton(
    child: Text("I'll do it later", style: TextStyle(fontSize: 16.0, fontFamily: "Poppins", color: Color(0xFFA3A2A2))),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget okayButton = ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.black, shape: StadiumBorder()),
      onPressed: () async {
        //do the saving of rating
        print('Saving rating');
        var url = Uri.parse(globals.apiAddress + '/rating');
        var data = await setRate(myemotion, myrating, url);
        print('Response of rating is ${data.toString()}');
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        child: Text("Submit!", style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Poppins")),
      )
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          // title: Text("It works!"),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          content: Container(
            height: 350,
            child: Column(
              children: [
                SizedBox(height: 20,),
                // Text('Are you feeling it?', textAlign: TextAlign.center,
                //   style: TextStyle(fontSize: 24.0,
                //     fontWeight: FontWeight.bold,
                //     fontFamily: "Poppins",),),
                myTitle('Are you feeling it?'),
                SizedBox(height: 10,),
                // Text('Please rate your playlist',
                //   style: TextStyle(fontSize: 16.0, fontFamily: "Poppins",),),
                mySubtitle('Please rate your playlist'),
                SizedBox(height: 50,),
                //stars
                RatingBar(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  // itemBuilder: (context, _) => {}
                  ratingWidget: RatingWidget(
                    full: SvgPicture.asset('assets/star_full.svg'),//Icon(Icons.star_rounded, color: Color(0xFFF9DB6F),),
                    half: SvgPicture.asset('assets/star_full.svg'),
                    empty: SvgPicture.asset('assets/star_empty.svg'),//Image.asset('assets/star_empty.svg'),
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      myrating = rating;
                    });
                    print(myrating);
                  },
                ),
                SizedBox(height: 50,),
                okayButton,
                SizedBox(height: 10,),
                noButton,
              ],
            ),
          ),
          // actions: [
          //   okayButton,
          // ],
        );
      });
    },
  );
}