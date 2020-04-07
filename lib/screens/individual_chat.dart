import 'package:flutter/material.dart';
import 'package:gupshop/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gupshop/service/message_service.dart';

class IndividualChat extends StatefulWidget {
  final String conversationId;
  final String userPhoneNo;
  final String userName;
  IndividualChat({Key key, @required this.conversationId, @required this.userPhoneNo, @required this.userName}) : super(key: key);
  @override
  _IndividualChatState createState() => _IndividualChatState(conversationId: conversationId,userPhoneNo: userPhoneNo,userName: userName);
}

class _IndividualChatState extends State<IndividualChat> {
  final String conversationId;
  final String userPhoneNo;
  final String userName;
  _IndividualChatState({@required this.conversationId, @required this.userPhoneNo, @required this.userName});

  String value ="";//TODo


  @override
  Widget build(BuildContext context) {
    //Firestore.instance.collection("conversations").document(conversationId).
//    Chats chats = Chats();
//    MessageService messageService = new MessageService();
//
//    print("Found conversationId ${conversationId}");
//
//    Firestore.instance.collection("conversations").document(conversationId).get().then((documentSnapshot){
//
//      print("Document Snapshot ${documentSnapshot.data["messageId"]}");
//      //messageService.getMessages(messageIds)
//      var messageIds = documentSnapshot.data["messageId"];
//      Stream<DocumentSnapshot> messageStream = Stream.fromFutures(messageService.getMessages(messageIds));

//      print("firestore call ${Firestore.instance.collection("conversation").document(conversationId).snapshots()}");

      //List<ChatMessage> chatMessages  = chats.getMessages();
    print("conversation: ${Firestore.instance.collection("conversations").document().snapshots()} ");

      CollectionReference collectionReference = Firestore.instance.collection("conversations");
      collectionReference.orderBy("timestamp",descending: false);

      print("where are we: ${Firestore.instance.collection("conversations").document().snapshots()}");

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
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),//to take out the keyboard when tapped on chat screen
            child: StreamBuilder<QuerySnapshot>(
              stream: collectionReference.document(conversationId).collection("messages").snapshots(),
              builder: (context, snapshot) {
                print("conversationId: $conversationId");
                print("snapshot of: ${collectionReference.document(conversationId).snapshots()}");
                print("snapshot data: ${snapshot.data.documents[0].data}");
//                print("Rohan ${snapshot.data.["messages"][1]}");
                var messageArray = snapshot.data.documents;

                messageArray.sort((a,b){
                  Timestamp timestamp1 = a.data["timeStamp"];
                  Timestamp timestamp2 = b.data["timeStamp"];
                  return timestamp1.compareTo(timestamp2);
                });
//              print("snapshot= ${snapshot.data.data["messages"][0]}");
                return ListView.separated(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                    var messageBody = snapshot.data.documents[index].data["body"];
                    var fromName = snapshot.data.documents[index].data["fromName"];
                    var timeStamp= snapshot.data.documents[index].data["timeStamp"];

                    return ListTile(
                      title: Container(
                        //fromName:userName? use following widget ToDo
                        margin: EdgeInsets.only(top: 8.0),
                        child: Text(//message
                          messageBody,
                        ),
                      ),
                      trailing: Text(//time
                        timeStamp.toString(),
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index)=> Divider(
                    color: Colors.white,
                  ),
                );
              }
            ),
          ),//body

          //bottomNavigationBar: for the sendMessageBox
          bottomNavigationBar: Transform.translate(//to make the sendMessageBox push up after the keyboard pops up
            offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
            child: BottomAppBar(
              child: Container(
                height: 80,
                child: ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.photo),
                  ),
                  title: TextField(
                    //textCapitalization: TextCapitalization.sentences,
                    onChanged: (value){
                      this.value=value;
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: (){
//                      print("fromName: $userName",);
//                      print("fromPhoneNumber: $userPhoneNo");
//                      print("timeStamp: $DateTime.now()");
                      var data = {"body":value, "fromName":userName, "fromPhoneNumber":userPhoneNo, "timeStamp":DateTime.now()};
                      Firestore.instance.collection("conversations").document(conversationId).collection("messages").add(data);

                      print("value: $value");
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
//    });


  }


}
