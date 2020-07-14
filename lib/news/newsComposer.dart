import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact/generated/i18n.dart';
import 'package:gupshop/news/fakeNewsText.dart';
import 'package:gupshop/news/newsComposerBody.dart';
import 'package:gupshop/service/addToFriendsCollection.dart';
import 'package:gupshop/service/recentChats.dart';
import 'package:gupshop/service/sendAndDisplayMessages.dart';
import 'package:gupshop/widgets/createMessageDataToPushToFirebase.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customScaffoldBody.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customTextFormField.dart';

class NewsComposer extends StatefulWidget {
  bool groupExits;
  String friendN;
  String userPhoneNo;
  String userName;
  List<dynamic> listOfFriendNumbers;
  String conversationId;
  String groupName;
  String value;
  TextEditingController controller;
  ScrollController listScrollController;

  NewsComposer({
    this.groupExits,
    this.friendN,
    this.userPhoneNo,
    this.userName,
    this.listOfFriendNumbers,
    this.conversationId,
    this.groupName,
    this.value,
    this.controller,
    this.listScrollController,
  });

  @override
  NewsComposerState createState() => NewsComposerState();
}

class NewsComposerState extends State<NewsComposer> {
  String title;

  String link;

  String newsBody;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: CustomAppBar(
            title: CustomText(text : 'Create a NEWS !'),
            onPressed: (){Navigator.pop(context);},
          ),

      ),
      body: CustomScaffoldBody(
        body: NewsComposerBody(
          children: <Widget>[
            CustomTextFormField(
              labelText: 'Enter the News Title',
              maxLength: 15,
              onChanged: (titleVal){
                setState(() {
                  title = titleVal;
                });
              },
            ),
            CustomTextFormField(
              labelText: 'Enter the News link',
              maxLines: 2,
              valForValidator: (val) => 'Link Required',
              onChanged: (linkVal){
                setState(() {
                  link = linkVal;
                  print("link in setState: $link");
                });
              },
            ),
            CustomTextFormField(
              labelText: 'Give some intro about the news',
              maxLines: 2,
              onChanged: (newsVal){
                setState(() {
                  newsBody = newsVal;
                });
              },
            ),
            CustomIconButton(
//              onPressed: widget.sendNewsOnPressed,
              onPressed: (){
                sendToRecentChatsAndConversations(
                    widget.groupExits, widget.friendN, widget.userPhoneNo, widget.userName,
                    widget.listOfFriendNumbers, widget.conversationId, widget.groupName,
                    widget.value, widget.controller, widget.listScrollController
                );
              },
              iconNameInImageFolder: 'paperPlane',
            ),
            FakeNewsText(),
          ],
        ),
      ),
    );
  }

  sendToRecentChatsAndConversations(
      bool groupExits, String friendN, String userPhoneNo, String userName,
      List<dynamic> listOfFriendNumbers, String conversationId, String groupName,
      String value, TextEditingController controller, ScrollController listScrollController) async {

    print("link in beginning : $link");

    if (groupExits == false) {
      var myNumberExistsInFriendsFriendsCollectionWaiting = await Firestore
          .instance.collection("friends_$friendN").document(userPhoneNo).get();
      var myNumberExistsInFriendsFriendsCollection = myNumberExistsInFriendsFriendsCollectionWaiting
          .data;
      if (myNumberExistsInFriendsFriendsCollection == null) {
        List<String> nameListForOthers = new List();
        nameListForOthers.add(userName);
        AddToFriendsCollection()
            .extractNumbersFromListAndAddToFriendsCollection(
            listOfFriendNumbers, conversationId, userPhoneNo, nameListForOthers,
            null, null);
      }
    }
    if (groupExits == true) {
      DocumentSnapshot adminNumberFuture = await Firestore.instance.collection(
          "conversationMetadata").document(conversationId).get();
      String adminNumber = adminNumberFuture.data["admin"];
      print("adminNumber: $adminNumber");

      await Future.wait(listOfFriendNumbers.map((element) async {
        print("element: $element");
        var myNumberExistsInFriendsFriendsCollectionWaiting = await Firestore
            .instance.collection("friends_$element")
            .document(conversationId)
            .get();
        var myNumberExistsInFriendsFriendsCollection = myNumberExistsInFriendsFriendsCollectionWaiting
            .data;
        print(
            "myNumberExistsInFriendsFriendsCollection: $myNumberExistsInFriendsFriendsCollection");
        if (myNumberExistsInFriendsFriendsCollection == null) {
          List<String> nameListForOthers = new List();
          nameListForOthers.add(groupName);
          AddToFriendsCollection()
              .extractNumbersFromListAndAddToFriendsCollection(
              listOfFriendNumbers, conversationId, conversationId,
              nameListForOthers, groupName, adminNumber);
        }
      }));
    }

    if (link != "") {
      ///if there is not text, then dont send the message
      print("link : $link");
      print("title : $title");
      print("news : $newsBody");
      var data = {
        "news": newsBody,
        "title" : title,
        "link" : link,
        "fromName": userName,
        "fromPhoneNumber": userPhoneNo,
        "timeStamp": DateTime.now(),
        "conversationId": conversationId
      };
      SendAndDisplayMessages().pushToFirebaseConversatinCollection(data);

      var dataForRecentChats = CreateMessageDataToPushToFirebase(isNews: true, userPhoneNo: userPhoneNo, userName: userName, conversationId: conversationId).create();

      ///Navigating to RecentChats page with pushes the data to firebase
      RecentChats(message: dataForRecentChats,
          convId: conversationId,
          userNumber: userPhoneNo,
          userName: userName,
          listOfOtherNumbers: listOfFriendNumbers,
          groupExists: groupExits).getAllNumbersOfAConversation();

      controller.clear(); //used to clear text when user hits send button
      listScrollController
          .animateTo( //for scrolling to the bottom of the screen when a next text is send
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }
}
