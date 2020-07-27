import 'package:flutter/cupertino.dart';
import 'package:gupshop/individualChat/updateSaveBoardCollection.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/updateInFirebase/updateBoardCollection.dart';
import 'package:gupshop/updateInFirebase/updateSaveCollection.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class HeartButton extends StatefulWidget {
  bool isSaved;
  String conversationId;
  String documentId;
  String messageId;

  HeartButton({@required this.isSaved, @required this.conversationId, @required this.documentId, @required this.messageId});

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
        /// update save collection
        UpdateSaveAndBoardCollection(messageId: widget.messageId, isSaved: widget.isSaved).update();
      },
    );
  }
}
