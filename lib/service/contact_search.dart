import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/models/message_model.dart';
import 'package:gupshop/screens/individual_chat.dart';

class ContactSearch extends SearchDelegate<String>{
  final String userPhoneNo;
  final String userName;

  ContactSearch({@required this.userPhoneNo, @required this.userName});
//  final Stream<List<Message>> streamMessages;
//  ContactSearch(this.streamMessages);

  @override
  List<Widget> buildActions(BuildContext context) {
    return[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query='';
        },
      ),
    ];

  //return  null;
  }

  @override
  Widget buildLeading(BuildContext context) {
//    return IconButton(
//      icon: Icon(Icons.arrow_back),
//      onPressed: (){
//        close(context, null);
//      },
//    );
  return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print("userphoneno in contact_search: ${userPhoneNo}");
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("friends_$userPhoneNo").snapshots(),//use userPhoneNo ToDo
        builder: (context, snapshot) {

          //final streamShortcut =Firestore.instance.collection("friends_9194134191").document("contacts").snapshots();

          if(snapshot.hasError) return Text("Error occurred");
          if(!snapshot.hasData) return Text("Now Loading!");

//          String friendName = snapshot.data.data["0"]["name"];
//          String friendPhoneNumber =  snapshot.data.data["0"]["id"];
//          print("snapshot data ${snapshot.data.data["0"]["id"]}");
//          print("Friend phone number ${friendPhoneNumber} and ${friendName}");
          print("snapshot.data.documents.length = ${snapshot.data.documents.length}" );

          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index){
                //final result = streamShortcut.where();
                print("snapshotdatadoc[index]data[convID] = ${snapshot.data.documents[index].data["conversationId"]}");
                print("userphoneno in contact_search in Listview Builder: ${userPhoneNo}");
                //print("userName:=${snapshot.data.documents[int.parse(userPhoneNo)].data["name"]}");
                return ListTile(
                  title: Text(
                      snapshot.data.documents[index].data["name"],
                  ),
                  onTap: (){
                    print("userphoneno in contact_search in ontap: ${userPhoneNo}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(//to send conversationId along with the navigator to the next page
                        builder: (context) => IndividualChat(
                          conversationId: snapshot.data.documents[index].data["conversationId"],
                          userPhoneNo: userPhoneNo,
                          userName: userName,
                          //snapshot.data.documents[int.parse(userPhoneNo)].data["name"],
                        ),
                      ),
                    );
                  },
                );
              },
          );

        }
    );
  }

//  Stream filter(){
//
//  }

}