import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/customText.dart';

class ReadUnreadDisplay extends StatelessWidget {
  const ReadUnreadDisplay({
    Key key,
    @required this.context,
    @required this.isRead,
    @required this.isMe,
  }) : super(key: key);

  final BuildContext context;
  final bool isRead;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isMe,
      child: Container(
        width: MediaQuery.of(context).size.width,
        alignment:  Alignment.centerRight,
        padding:  EdgeInsets.symmetric(horizontal: 15.0, vertical: 1.0),
        child: isRead == true ? CustomText(text: 'read',).blueSubtitle() : CustomText(text: 'unread',fontSize: 12,).graySubtitleItalic(),
      ),
    );
  }
}