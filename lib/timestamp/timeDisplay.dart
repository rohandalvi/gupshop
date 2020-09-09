import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:intl/intl.dart';

class TimeDisplay extends StatelessWidget {
  final Timestamp timeStamp;

  TimeDisplay({this.timeStamp});

  @override
  Widget build(BuildContext context) {
    return Text(//time
        DateFormat("dd MMM kk:mm")
            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp.millisecondsSinceEpoch.toString()))),//converting firebase timestamp to pretty print
        style: TextStyle(
            color: Colors.grey, fontSize: TextConfig.fontSizeTwelve, fontStyle: FontStyle.italic
        )
    );
  }
}
