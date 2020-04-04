import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/models/message_model.dart';

class ContactSearch extends SearchDelegate<String>{
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
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance.collection("friends_9194134191").document("contacts").snapshots(),
        builder: (context, snapshot) {


          if(snapshot.hasError) return Text("Error occurred");
          if(!snapshot.hasData) return Text("Now Loading!");

          String friendName = snapshot.data.data["0"]["name"];
          String friendPhoneNumber =  snapshot.data.data["0"]["id"];
          print("snapshot data ${snapshot.data.data["0"]["id"]}");
          print("Friend phone number ${friendPhoneNumber} and ${friendName}");
          return ListView.builder(
              itemCount: snapshot.data.data.length,
              itemBuilder: (context, index){

                return ListTile(
                  title: Text(snapshot.data.data[index.toString()]["name"]),
                );
              },
          );

        }
    );
  }

}