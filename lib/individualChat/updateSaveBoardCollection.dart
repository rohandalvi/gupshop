import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/retriveFromFirebase/getMessageBodyFromSaveCollection.dart';
import 'package:gupshop/updateInFirebase/updateBoardCollection.dart';
import 'package:gupshop/updateInFirebase/updateSaveCollection.dart';

class UpdateSaveAndBoardCollection{
  bool isSaved;
  String messageId;

  UpdateSaveAndBoardCollection({this.isSaved, this.messageId});


  update() async{
    UpdateSaveCollection(isSaved : isSaved, messageId : messageId,).updateIsSaved();

    /// if widget.isSaved == true :
    /// save to users' saved collection:
    String body = await GetMessageBodyFromSaveCollection(messageId: messageId).getBody();
    String userNumber = await UserDetails().getUserPhoneNoFuture();
    String boardName = 'general';
    UpdateBoardCollection(userNumber : userNumber, boardName: boardName, isSaved : isSaved, messageId : messageId).update();
  }

}