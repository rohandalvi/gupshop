import 'package:flutter/cupertino.dart';
import 'package:gupshop/updateInFirebase/UpdateConversationCollection.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class HeartButton extends StatefulWidget {
  bool isSaved;
  String conversationId;
  String documentId;

  HeartButton({@required this.isSaved, @required this.conversationId, @required this.documentId});

  @override
  _HeartButtonState createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton> {

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      iconNameInImageFolder: widget.isSaved == true ? 'redHeart' : 'whiteHeart',
      onPressed: () {
        if(widget.isSaved == true){
          setState(() {
            widget.isSaved = false;
          });
        } else setState(() {
          widget.isSaved = true;
        });
        UpdateConversationCollection(isSaved : widget.isSaved, conversationId: widget.conversationId, documentId: widget.documentId,).update();
      },
    );
  }
}
