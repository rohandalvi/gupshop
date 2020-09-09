import 'package:flutter/cupertino.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/widgets/customText.dart';

class UnreadDisplay extends StatelessWidget {
  const UnreadDisplay({
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment:  Alignment.centerRight,
      padding:  EdgeInsets.symmetric(horizontal: PaddingConfig.fifteen,
          vertical: PaddingConfig.one),
      child: CustomText(text: 'unread',).graySubtitleItalic(),
    );
  }
}