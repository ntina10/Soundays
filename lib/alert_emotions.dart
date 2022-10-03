import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soundays/myElements.dart';

showAlertDialogEmo(BuildContext context, Map emotions) {

  Map emotionMap = {
    'surprise': 'surprised',
    'anger': 'angry',
    'disgust': 'disgust',
    'fear': 'fear',
    'happiness': 'happy',
    'sadness': 'sad',
    'neutral': 'neutral'
  };

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                // height: 595,
                // width: 300,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height /20,),
                    myTitle('These are\nyour results:'),
                    SizedBox(height: MediaQuery.of(context).size.height / 20,),
                    Container(
                      height: 320,
                      width: 180,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: emotions.length,
                        itemBuilder: (BuildContext context, int index) {
                          String key = emotions.keys.elementAt(index);
                          return Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  SizedBox(height: 32, width: 32, child: Image.asset('assets/' + emotionMap[key] + '.png'),),
                                  SizedBox(width: 16,),
                                  Text((emotions[key]*100).toStringAsFixed(2) + '%',  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Poppins",) ),
                                  Text(' ' + emotionMap[key])
                                ],
                              ),
                              if (index != emotions.length -1) SizedBox(height: 16,),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 20,),
                    myButton(() { Navigator.pop(context);}, 'Close'),
                    SizedBox(height: MediaQuery.of(context).size.height / 20,)
                  ],
                ),
              ),
            ],
          ),

        );
      });
    }
  );
}