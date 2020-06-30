import 'package:flutter/cupertino.dart';

//class FromNameAndTimeStamp extends StatefulWidget {
//  bool visible;
//  Widget fromName;
//  bool isMe;
//  Widget timeStamp;
//
//  FromNameAndTimeStamp({this.visible, this.fromName, this.isMe, this.timeStamp});
//  @override
//  _FromNameAndTimeStampState createState() => _FromNameAndTimeStampState(visible: visible, fromName: fromName, isMe: isMe, timeStamp: timeStamp);
//}

class FromNameAndTimeStamp extends StatelessWidget {
  bool visible;
  Widget fromName;
  bool isMe;
  Widget timeStamp;

  FromNameAndTimeStamp({this.visible, this.fromName, this.isMe, this.timeStamp});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          visible: visible,
          child: Container(
              width: MediaQuery.of(context).size.width,
              alignment:  Alignment.centerLeft,
              padding:  EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
              child: fromName,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          alignment: isMe? Alignment.centerRight: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),//pretty padding- for some margin from the side of the screen as well as the top of parent message
          child: timeStamp,
        ),
      ],
    );
  }
}