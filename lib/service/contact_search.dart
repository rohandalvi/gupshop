import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/models/message_model.dart';
import 'package:gupshop/screens/individual_chat.dart';

class ContactSearch extends SearchDelegate<String>{
  final String userPhoneNo;
  final String userName;

  ContactSearch({@required this.userPhoneNo, @required this.userName});

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

          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index){
                //final result = streamShortcut.where();
                print("userName= $userName");
                print("snapshotdatadoc[index]data[convID] = ${snapshot.data.documents[index].data["conversationId"]}");
                print("userphoneno in contact_search in Listview Builder: ${userPhoneNo}");
                //print("userName:=${snapshot.data.documents[int.parse(userPhoneNo)].data["name"]}");
                print("userName= $userName");
                return ListTile(
                  title: Text(
                      snapshot.data.documents[index].data["name"],
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(//to send conversationId along with the navigator to the next page
                        builder: (context) => IndividualChat(
                          conversationId: snapshot.data.documents[index].data["conversationId"],
                          userPhoneNo: userPhoneNo,
                          userName: userName,
                          friendName: snapshot.data.documents[index].data["name"],
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