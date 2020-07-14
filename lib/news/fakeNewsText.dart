import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/customText.dart';

class FakeNewsText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomText(
        text: 'Sharing FAKE NEWS or UNVERIFIED NEWS is a legally and morally irresponsible act. In case of problem(change the word problem), you would be held responsible for the news in the court of law. Think very carefully before sharing or creating a news.',
      ),
    );
  }
}
