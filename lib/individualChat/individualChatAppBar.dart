import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/modules/Presence.dart';
import 'package:gupshop/navigators/navigateToChangeProfilePicture.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/image/changeProfilePicture.dart';
import 'package:gupshop/service/conversation_service.dart';
import 'package:gupshop/image/displayAvatar.dart';
import 'package:gupshop/widgets/CustomFutureBuilder.dart';
import 'package:gupshop/individualChat/chatAppBar.dart';
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
  bool groupDeleted;
  String imageURL;
  double radius;
  double innerRadius;


  IndividualChatAppBar({this.userName, this.userPhoneNo, this.groupExits,
    this.friendName, this.friendN, this.conversationId, this.notGroupMemberAnymore,
    this.listOfFriendNumbers,this.presence, this.conversationService, this.chatListCache,
    this.groupDeleted,this.imageURL
  }): radius = ImageConfig.smallRadius,/// 25
        innerRadius = ImageConfig.smallInnerRadius;///23.5

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

  bool conversationExists(){
    return ((widget.notGroupMemberAnymore == false || widget.notGroupMemberAnymore == null)
        && (widget.groupDeleted == false || widget.groupDeleted == null));
  }


  @override
  Widget build(BuildContext context) {
    return ChatAppBar(
      backOnPressed: () async{
        /// if a person is removed from the group, then the subscription
        /// cannot be cancelled.
        /// Hence, first check if he is a member or not.
        if(conversationExists() == true){
          await widget.conversationService.disableActiveSubscription();
        }
        Navigator.pop(context);

//        CustomNavigator().navigateToHome(context, widget.userName, widget.userPhoneNo);
      },

      avatarOnPressed: (){
        if(isGroup()){
          /// if  its a group, then change profile picture can be done by anyone
          changeProfilePicture(context);
        }
        /// if an individual, then only the view option and not
        /// the change options are visible
        NavigateChangeProfilePicture(
          userName: widget.friendName,
          viewingFriendsProfile: true,
          userPhoneNo: widget.friendN,
          groupConversationId: null,
          imageURL: widget.imageURL
        ).navigateNoBrackets(context);
        //else CustomNavigator().navigateToChangeProfilePicture(context, widget.friendName,  true, widget.friendN, null, widget.imageURL);/// if its a group then profile pictures are searched using conversationId
      },

      displayPictureAvatar: displayPictureAvatar(),
      name: FittedBox(child: CustomText(text: widget.friendName,)),/// to avoid text getting hidden
      nameOnPressed: (){
        if(isGroup()){
          /// if its a group, then on clicking the name,
          /// a dialog box appears which displays the name of the
          /// members, where the members can be deleted
          groupMemberDialogHelper(userNumber: widget.userPhoneNo, listOfGroupMemberNumbers: widget.listOfFriendNumbers,
              conversationId: widget.conversationId, isGroup: widget.groupExits).customShowDialog(context);
        }
      },
      conversationId: widget.conversationId,
      userName: widget.userName,
      userPhoneNo: widget.userPhoneNo,
      groupExits: widget.groupExits,
      presence: CustomFutureBuilder(future: widget.presence.getStatus(widget.friendN),
          dataReadyWidgetType: CustomText, inProgressWidget: CustomText(text: 'Offline',).graySubtitle()),
      presenceVisibility: isIndividual(),
    );
  }

  bool isIndividual() => widget.groupExits == false ||  widget.groupExits == null;/// a group will have groupExits== null because in database we are storing it as null
  bool isGroup() => widget.groupExits == true && widget.notGroupMemberAnymore == false;

  /// when an individualChat is created as a result of bazaar, we dont share their numbers
  /// to each other, so here friendN would be null.
  bool isIndividualNonBazaarContact() => widget.groupExits == false && widget.friendN != null;


  displayPictureAvatar(){
    //da = DisplayAvatar(imageUrl: imageURL).displayAvatarFromFirebase(widget.friendN, 25, 23.5, false);
    /// take value from chatListCache


    /// if the chat is coming from bazaar then chatListCache would be
    /// be null, hence this check chatListCache != null
    if(widget.chatListCache != null) {
      return widget.chatListCache.containsKey(widget.conversationId) == true ?
      widget.chatListCache[widget.conversationId].circleAvatar :
      widget.friendN == null
          ? DisplayAvatar().avatarPlaceholder(widget.radius, widget.innerRadius)
          : DisplayAvatar().displayAvatarFromFirebase(widget.friendN, widget.radius, widget.innerRadius, false);
    }else{
      return widget.friendN == null
          ? DisplayAvatar().avatarPlaceholder(widget.radius, widget.innerRadius)
          : DisplayAvatar().displayAvatarFromFirebase(widget.friendN, widget.radius, widget.innerRadius, false);
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
            chatListCache: widget.chatListCache,
            imageURL: widget.imageURL,
          ),//pass Name() here and pass Home()in name_screen
        )
    );
    setState(() {
      checkCache = false;

    });

    return result;
  }
}
