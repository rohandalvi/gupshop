import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gupshop/models/message_model.dart';

class ContactSearch extends SearchDelegate<String>{
  final Stream<List<Message>> streamMessages;
  ContactSearch(this.streamMessages);

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
    return Text(query);
  }

}