import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/chat_list_page/avatarDisplay.dart';
import 'package:gupshop/chat_list_page/chatListCache.dart';
import 'package:gupshop/chat_list_page/chatListTrace.dart';
import 'package:gupshop/chat_list_page/subtitleDataAndDisplay.dart';
import 'package:gupshop/chat_list_page/trailingDisplay.dart';
import 'package:gupshop/dataGathering/myTrace.dart';
import 'package:gupshop/individualChat/individual_chat.dart';
import 'package:gupshop/image/displayAvatar.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/retriveFromFirebase/conversationMetaData.dart';
import 'package:gupshop/service/findFriendNumber.dart';
import 'package:gupshop/widgets/customText.dart';

class ChatListDisplay extends StatefulWidget {
  final String myNumber;
  final String conversationId;
  bool notAGroupMemberAnymore;
  bool groupExists;
  String friendNumber;
  List<dynamic> friendNumberList;
  List<dynamic> memberList;
  String friendName;
  final bool lastMessageIsVideo;
  final int index;
  String lastMessage;
  bool lastMessageIsImage;
  final Timestamp timeStamp;
  String myName;
  Map<String, ChatListCache> chatListCache;
  String conversationsLatestMessageId;
  String imageURL;
  double radius;
  double innerRadius;

  ChatListDisplay({this.myNumber, this.conversationId, this.notAGroupMemberAnymore,
    this.groupExists, this.friendNumber, this.memberList, this.friendNumberList,
    this.friendName, this.lastMessageIsVideo, this.index, this.lastMessage,
    this.lastMessageIsImage, this.timeStamp, this.myName, this.chatListCache,
    this.conversationsLatestMessageId,this.imageURL
  }): radius = ImageConfig.smallRadius,/// 30
        innerRadius = ImageConfig.smallInnerRadius;
  @override
  _ChatListDisplayState createState() => _ChatListDisplayState();
}

class _ChatListDisplayState extends State<ChatListDisplay> {
  bool groupDeleted;
  AvatarDisplay avatar;


  @override
  void initState() {
    getFriendNumber();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile( ///main widget that creates the message box
      leading:
      /// leading is avatar
      /// check if the avatar is in the cache.
      /// if not, then call the futurebuilder,
      /// else return froom the cache
      cachedData(context),

      title: CustomText(text: widget.friendName),
      subtitle: SubtitleDataAndDisplay(
        lastMessage: widget.lastMessage,
        lastMessageIsImage: widget.lastMessageIsImage,
        lastMessageIsVideo: widget.lastMessageIsVideo,
        index: widget.index,
        myNumber: widget.myNumber,
      ),
      /// read unread icon display:
      trailing: TrailingDisplay(
        groupExists: widget.groupExists,
        friendNumber: widget.friendNumber,
        conversationId: widget.conversationId,
        myNumber: widget.myNumber,
        timeStamp: widget.timeStamp,
        conversationsLatestMessageId: widget.conversationsLatestMessageId,
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  IndividualChat(
                    chatListCache: widget.chatListCache,
                    friendName: widget.friendName,
                    conversationId: widget.conversationId,
                    userName: widget.myName,
                    userPhoneNo: widget.myNumber,
                    listOfFriendNumbers: widget.friendNumberList,
                    notGroupMemberAnymore: widget.notAGroupMemberAnymore,
                    groupDeleted: groupDeleted,
                    imageURL: widget.imageURL,
                  ), //pass Name() here and pass Home()in name_screen
            )
        );
      },
    );
  }


  /// friend number and groupExists is not actually going to trailingDisplay
  /// so, we need to make an explicit call to get it.
  /// It is actually getting set in cachedData, but we cannot setState there
  /// as it is called in build, so it is not getting set globally
  Future<void> getFriendNumber() async{
    Map<String, dynamic> dc = await ConversationMetaData(conversationId:widget.conversationId, ).get( widget.myNumber);
    widget.memberList = dc[TextConfig.conversationMetadataMembers];
    bool isGroup;
    if (dc[TextConfig.conversationMetadataGroupName] == null){
      isGroup = false;
    }else{
      isGroup = true;
    }
    setState(() {
      widget.groupExists = isGroup;
      widget.friendNumber =
          FindFriendNumber().friendNumber(widget.memberList, widget.myNumber);
    });
  }

  cacheAvatar(){
    return widget.chatListCache[widget.conversationId].circleAvatar;
  }

  cachedData(BuildContext context){
    ChatListTrace chatListTrace = new ChatListTrace();

    /// if its a group and its cached:
    if( widget.chatListCache.containsKey(widget.conversationId) == true && widget.chatListCache[widget.conversationId].isGroup == true){
      /// TRACE
      chatListTrace.cachedAvatarHit();

      return FutureBuilder(
        future: ConversationMetaData(conversationId:widget.conversationId, ).get( widget.myNumber),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            widget.memberList = snapshot.data[TextConfig.conversationMetadataMembers];

            /// first check if the group is deleted
            if(widget.memberList.isEmpty == true) groupDeleted = true;

            /// if a member is removed from the group, then he should not be seeing the conversations
            /// once he enters the individual chat page
            else if (widget.memberList.contains(widget.myNumber) == false)
              widget.notAGroupMemberAnymore = true;

            if (snapshot.data[TextConfig.conversationMetadataGroupName] == null) {
              widget.groupExists = false;

              /// 1. extract memberList from conversationMetadata for navigating to individualChat
              widget.memberList = snapshot.data[TextConfig.conversationMetadataMembers];

              /// 2. extract friendNumber for DisplayAvatarFromFirebase

                widget.friendNumber =
                    FindFriendNumber().friendNumber(widget.memberList, widget.myNumber);


              /// 3. create friendNumberList to send to individualChat
              widget.friendNumberList =
                  FindFriendNumber().createListOfFriends(widget.memberList, widget.myNumber);
            } else {
              widget.groupExists = true;

              /// for groups, conversationId is used as documentId for
              /// getting profilePicture
              /// profile_pictures -> conversationId -> url
              widget.friendNumberList =
                  FindFriendNumber().createListOfFriends(widget.memberList, widget.myNumber);
              widget.friendNumber = widget.conversationId;
            }
            return cacheAvatar();
          }
          return cacheAvatar();
        },
      );
      /// if  individualChat and its cached:
    }else if(widget.chatListCache.containsKey(widget.conversationId) == true){
      /// TRACE
      chatListTrace.cachedAvatarHit();

      widget.memberList = widget.chatListCache[widget.conversationId].memberList;
      widget.groupExists = false;


      /// 1. extract friendNumber for DisplayAvatarFromFirebase
        widget.friendNumber =
            FindFriendNumber().friendNumber(widget.memberList, widget.myNumber);


      /// 2. create friendNumberList to send to individualChat
      widget.friendNumberList =
          FindFriendNumber().createListOfFriends(widget.memberList, widget.myNumber);
      return cacheAvatar();
    }
    /// if any type of chat and its not cached:
    else if (widget.chatListCache.containsKey(widget.conversationId) == false){
      /// TRACE
      chatListTrace.nonCachedAvatarHit();

      return FutureBuilder(
        future: ConversationMetaData(conversationId: widget.conversationId).get(widget.myNumber),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            widget.memberList = snapshot.data[TextConfig.conversationMetadataMembers];
            ChatListCache cache = new ChatListCache();
            cache.memberList = widget.memberList;/// adding to cache

            /// if a member is removed from the group, then he should not be seeing the conversations
            /// once he enters the individual chat page
            if (widget.memberList.contains(widget.myNumber) == false)
              widget.notAGroupMemberAnymore = true;

            if (snapshot.data[TextConfig.conversationMetadataGroupName] == null) {
              widget.groupExists = false;

              /// 1. extract memberList from conversationMetadata for navigating to individualChat
              widget.memberList = snapshot.data["members"];

              /// 2. extract friendNumber for DisplayAvatarFromFirebase
                widget.friendNumber =
                    FindFriendNumber().friendNumber(widget.memberList, widget.myNumber);

              /// 3. create friendNumberList to send to individualChat
              widget.friendNumberList =
                  FindFriendNumber().createListOfFriends(widget.memberList, widget.myNumber);
            } else {
              widget.groupExists = true;

              /// for groups, conversationId is used as documentId for
              /// getting profilePicture
              /// profile_pictures -> conversationId -> url
              widget.friendNumberList =
                  FindFriendNumber().createListOfFriends(widget.memberList, widget.myNumber);
              widget.friendNumber = widget.conversationId;
            }
            cache.isGroup = widget.groupExists;

            return avatarWidget(cache);
          }
          return DisplayAvatar().avatarPlaceholder(widget.radius, widget.innerRadius);
        },
      );
    }
  }

  AvatarDisplay avatarWidget(ChatListCache cache){
    return AvatarDisplay(
      userPhoneNo: widget.friendNumber,
      radius: widget.radius,
      innerRadius: widget.innerRadius,
      isFirstTime: false,
      chatListCache: widget.chatListCache,
      conversationId: widget.conversationId,
      cache: cache,
      imageUrl: (setImageURL){
          widget.imageURL = setImageURL;
      },
    );
  }
}
