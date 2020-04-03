import 'package:flutter/material.dart';
import 'package:gupshop/models/message_model.dart';
import 'package:gupshop/screens/home.dart';

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(//to create the seperated view of each chat, has to be used with separatorBuilder: (context, index) => Divider
        itemCount: chats.length,
        itemBuilder: (context, index){
          return ListTile(//main widget that creates the message box
            leading: CircleAvatar(
              radius: 35,
              //backgroundImage: AssetImage(chats[index].sender.imageUrl),
            ),
            title: Text(chats[index].sender.name,),
            subtitle: Text(chats[index].text,),
            //dense: true,
            trailing: Text(//time
                chats[index].time,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            onTap: (){
              Navigator.pushNamed(context, "individualChat");
            },
          );
        },
      separatorBuilder: (context, index) => Divider(//to divide the chat list
        color: Colors.white,
      ),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: Home().appBarScaffold(),
//      body: ListView.separated(//to create the seperated view of each chat, has to be used with separatorBuilder: (context, index) => Divider
//        itemCount: chats.length,
//        itemBuilder: (context, index){
//          return ListTile(//main widget that creates the message box
//            leading: CircleAvatar(
//              radius: 35,
//              //backgroundImage: AssetImage(chats[index].sender.imageUrl),
//            ),
//            title: Text(chats[index].sender.name,),
//            subtitle: Text(chats[index].text,),
//            //dense: true,
//            trailing: Text(//time
//              chats[index].time,
//              style: TextStyle(
//                fontSize: 12,
//              ),
//            ),
//            onTap: (){
//              Navigator.pushNamed(context, "individualChat");
//            },
//          );
//        },
//        separatorBuilder: (context, index) => Divider(//to divide the chat list
//          color: Colors.white,
//        ),
//      ),
//    );
//  }
}
