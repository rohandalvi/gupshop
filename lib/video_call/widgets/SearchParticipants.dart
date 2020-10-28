
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/responsive/collectionPaths.dart';
import 'package:gupshop/video_call/room/join_room_dummy.dart';
import 'package:gupshop/video_call/room/room_model.dart';
import 'package:gupshop/widgets/customSearch.dart';
import 'package:gupshop/widgets/customText.dart';

class SearchParticipants extends StatefulWidget {

  final RoomModel roomModel;
  SearchParticipants({this.roomModel});
  @override
  State<StatefulWidget> createState() => _SearchParticipantsState();

}

class _SearchParticipantsState extends State<SearchParticipants> {

  List<DocumentSnapshot> contacts = List();

  @override
  void initState() {
    // TODO: implement initState
    getContacts();
    
    super.initState();
  }
  void getContacts() async{
    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
    var snapshot = await CollectionPaths.getFriendsCollectionPath(userPhoneNo: userPhoneNo)
        .where('groupName', isNull: true)
        .where('isMe', isNull: true)
        .getDocuments();
    setState(() {
      contacts = snapshot.documents;
    });

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: <Widget>[
          widgetBody(context)
        ],
      ),
    );
  }



  Widget widgetBody(BuildContext context) {

    return CustomSearch<String>(
      backButton: (){
        Navigator.pop(context);
      },
      suggestions: contacts.map((e) => e.data["nameList"][0].toString()).toList(),
      onSearch: onSearch,
      hintText: 'Choose contact',
      onItemFound: (String name, int index) {
          return buildList(name, index);
        },
    );
  }

  Future<List<String>> onSearch(String text) {
    return new Future.delayed(const Duration(milliseconds: 1),
            () => contacts
                .where((contact) =>
            contact.data["nameList"][0].toLowerCase().contains(text.toLowerCase())
                || contact.documentID.contains(text)).map((e) => e.data["nameList"][0].toString()).toList());
  }

  Widget buildList(String name, int index) {
    return ListTile(
      title: CustomText(text: name,),
      onTap: () {
        String phoneNumber = contacts[index].documentID;
        print("RoomModel is ${widget.roomModel} and phoneNumber is $phoneNumber}");
        VideoCallRoomNavigator().sendRoomInvite(widget.roomModel, phoneNumber);
        Navigator.pop(context, {"name": name, "phoneNumber": phoneNumber});
      },
    );
  }
}