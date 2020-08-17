import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/individualChat/streamSingleton.dart';
import 'package:gupshop/modules/Presence.dart';
import 'package:gupshop/navigators/navigateToChangeProfilePicture.dart';
import 'package:gupshop/navigators/navigateToIndividualChatAppBar.dart';
import 'package:gupshop/screens/changeProfilePicture.dart';
import 'package:gupshop/service/conversation_service.dart';
import 'package:gupshop/image/displayAvatar.dart';
import 'package:gupshop/widgets/CustomFutureBuilder.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/widgets/customDialogBox.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/widgets/customText.dart';

class IndividualChatAppBar extends StatefulWidget {
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
  Map<String, ChatListCache> chatListCache;


  IndividualChatAppBar({this.userName, this.userPhoneNo, this.groupExits,
    this.friendName, this.friendN, this.conversationId, this.notGroupMemberAnymore,
    this.listOfFriendNumbers,this.presence, this.conversationService, this.chatListCache,
  });

  @override
  _IndividualChatAppBarState createState() => _IndividualChatAppBarState();
}

class _IndividualChatAppBarState extends State<IndividualChatAppBar> {
  bool checkCache;

  @override
  void initState() {
    if(widget.chatListCache != null){/// to avoid The method 'containsKey' was called on null.
      checkCache = widget.chatListCache.containsKey(widget.conversationId);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("friendN : ${widget.friendN}");
    return AppBar(
      backgroundColor: secondryColor.withOpacity(.03),
      elevation: 0,
      leading: IconButton(
          icon: SvgPicture.asset('images/backArrowColor.svg',),
          onPressed:() async{
            /// on back navigation.
            print("hashcode in indivichat : ${widget.conversationService.hashCode}");
            await widget.conversationService.disableActiveSubscription();
            //streamSingleton.setStream(null);
            CustomNavigator().navigateToHome(context, widget.userName, widget.userPhoneNo);
          }
      ),
      title: Material(
        child: ListTile(
          contentPadding: EdgeInsets.all(4),
          //EdgeInsets.only(top: 4),
          leading: GestureDetector(
            onTap: (){
              if(isGroup()){
                /// if  its a group, then change profile picture can be done by anyone
                changeProfilePicture(context);
              }
              else CustomNavigator().navigateToChangeProfilePicture(context, widget.friendName,  true, widget.friendN, null);/// if its a group then profile pictures are searched using conversationId
            },
            child: displayPictureAvatar(),
          ) ,
          title: GestureDetector(
              child: CustomText(text: widget.friendName,),
              onTap:(){
                if(isGroup()){
                  groupMemberDialogHelper(userNumber: widget.userPhoneNo, listOfGroupMemberNumbers: widget.listOfFriendNumbers, conversationId: widget.conversationId, isGroup: isIndividual()).customShowDialog(context);
                }
              }
          ),
          subtitle:Visibility(
              visible: isIndividual(),
              //isIndividualNonBazaarContact(),//widget.groupExits == false,////
              child: CustomFutureBuilder(future: widget.presence.getStatus(widget.friendN), dataReadyWidgetType: CustomText, inProgressWidget: CustomText(text: 'Offline',).graySubtitle())),
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

  bool isIndividual() => widget.groupExits == false ||  widget.groupExits == null;/// a group will have groupExits== null because in database we are storing it as null
  bool isGroup() => widget.groupExits == true && widget.notGroupMemberAnymore == false;

  /// when an individualChat is created as a result of bazaar, we dont share their numbers
  /// to each other, so here friendN would be null.
  bool isIndividualNonBazaarContact() => widget.groupExits == false && widget.friendN != null;

  displayPictureAvatar(){
    /// take value from chatListCache


    /// if the chat is coming from bazaar then chatListCache would be
    /// be null, hence this check chatListCache != null
    if(widget.chatListCache != null) {
      return widget.chatListCache.containsKey(widget.conversationId) == true ?
      widget.chatListCache[widget.conversationId].circleAvatar :
      widget.friendN == null
          ? DisplayAvatar().avatarPlaceholder(25, 23.5)
          : DisplayAvatar().displayAvatarFromFirebase(widget.friendN, 25, 23.5, false);
    }else{
      return widget.friendN == null
          ? DisplayAvatar().avatarPlaceholder(25, 23.5)
          : DisplayAvatar().displayAvatarFromFirebase(widget.friendN, 25, 23.5, false);
    }
  }

  changeProfilePicture(BuildContext context) async{
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeProfilePicture(
            userName: widget.friendName,
            viewingFriendsProfile:false,
            userPhoneNo: widget.friendN,
            groupConversationId: widget.conversationId,
            conversationId: widget.conversationId,
            chatListCache: widget.chatListCache,),//pass Name() here and pass Home()in name_screen
        )
    );
    setState(() {
      checkCache = false;
    });

    return result;
  }
}
