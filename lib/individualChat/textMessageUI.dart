import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/customText.dart';

class TextMessageUI extends StatelessWidget {
  final String messageBody;
  final bool isMe;

  TextMessageUI({this.messageBody, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*0.65,
      alignment: isMe? Alignment.centerRight: Alignment.centerLeft,
      child: CustomText(text: messageBody,),
    );
  }
}
