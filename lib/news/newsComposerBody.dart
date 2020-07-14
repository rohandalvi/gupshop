import 'package:flutter/cupertino.dart';

class NewsComposerBody extends StatelessWidget {
  List<Widget> children;

  NewsComposerBody({this.children});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: children,
    );
  }
}
