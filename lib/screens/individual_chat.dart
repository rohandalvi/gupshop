import 'package:flutter/material.dart';
import 'package:gupshop/models/message_model.dart';

class IndividualChat extends StatefulWidget {
  @override
  _IndividualChatState createState() => _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChat> {
  @override
  Widget build(BuildContext context) {
    Chats chats = Chats();
    List<ChatMessage> chatMessages  = chats.getMessages();
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Material(
            color: Theme.of(context).primaryColor,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(),
                leading: CircleAvatar(),
                title: Text(
                  'SenderName',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Put last seen here',
                ),
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
        ),
        body: ListView.separated(
            itemCount: chatMessages.length,
            itemBuilder: (context, index){
              return ListTile(
                title: Text(//message
                    chatMessages[index].text,
                ),
                trailing: Text(//time
                    chatMessages[index].time.toString(),
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),

              );
            },
            separatorBuilder: (context, index)=> Divider(
              color: Colors.white,
            ),
        ),
      ),
    );
  }
}
//title: Row(
//children: <Widget>[
//CircleAvatar(),
//Text(
//'SenderName',
//style: TextStyle(
//color: Colors.white,
//),
//),
//],
//),