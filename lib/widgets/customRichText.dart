import 'package:flutter/cupertino.dart';

class CustomRichText extends StatelessWidget {

  final List<InlineSpan> children;

  CustomRichText({this.children});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
        TextSpan(
          children: children,
        ),
    );
  }
}
