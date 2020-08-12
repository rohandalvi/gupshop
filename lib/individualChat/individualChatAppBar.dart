import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/individualChat/streamSingleton.dart';
import 'package:gupshop/modules/Presence.dart';
import 'package:gupshop/service/conversation_service.dart';
import 'package:gupshop/service/displayAvatarFromFirebase.dart';
import 'package:gupshop/widgets/CustomFutureBuilder.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/widgets/customDialogBox.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/widgets/customText.dart';

class IndividualChatAppBar extends StatelessWidget {
  String userName;
  String userPhoneNo;
  bool groupExits;
  String friendName;
  String friendN;
  String conversationId;
  bool notGroupMemberAnymore;
  List<dynamic> listOfFriendNumbers;
  final Presence presence;
  ConversationService conversationService;


  IndividualChatAppBar({this.userName, this.userPhoneNo, this.groupExits,
    this.friendName, this.friendN, this.conversationId, this.notGroupMemberAnymore,
    this.listOfFriendNumbers,this.presence, this.conversationService
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: secondryColor.withOpacity(.03),
      elevation: 0,
      leading: IconButton(
          icon: SvgPicture.asset('images/backArrowColor.svg',),
          onPressed:() async{
            /// on back navigation.
            print("hashcode in indivichat : ${conversationService.hashCode}");
            await conversationService.disableActiveSubscription();
            //streamSingleton.setStream(null);
            CustomNavigator().navigateToHome(context, userName, userPhoneNo);
          }
      ),
      title: Material(
        //color: Theme.of(context).primaryColor,
        child: ListTile(
          contentPadding: EdgeInsets.only(top: 4),
          leading: GestureDetector(
            onTap: (){
              if(groupExits){
                /// if  its a group, then change profile picture can be done by anyone
                CustomNavigator().navigateToChangeProfilePicture(context, friendName,  false, friendN, conversationId);/// if its a group then profile pictures are searched using conversationId
                /// if curfew on for group then  change profile picture can be done by only by admin
//                if(iAmAdmin == true){
//                  CustomNavigator().navigateToChangeProfilePicture(context, friendName,  false, friendN, conversationId);/// if its a group then profile pictures are searched using conversationId
//                }
              }
              else CustomNavigator().navigateToChangeProfilePicture(context, friendName,  true, friendN, null);/// if its a group then profile pictures are searched using conversationId
            },
            child: friendN == null ? CircularProgressIndicator() : DisplayAvatarFromFirebase().displayAvatarFromFirebase(friendN, 25, 23.5, false),
          ),
          title: GestureDetector(
              child: CustomText(text: friendName,),
              onTap:(){
                if(groupExits == true && notGroupMemberAnymore == false){
                  DialogHelper(userNumber: userPhoneNo, listOfGroupMemberNumbers: listOfFriendNumbers, conversationId: conversationId, isGroup: groupExits).customShowDialog(context);
                }
              }
          ),
          //CustomText(text: presence.getStatus(friendN)).subTitle()
          subtitle: new CustomFutureBuilder(future: presence.getStatus(friendN), dataReadyWidgetType: CustomText, inProgressWidget: CircularProgressIndicator()),
          trailing: Wrap(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.video_call),
              ),
              IconButton(
                icon: Icon(Icons.phone),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
