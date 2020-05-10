//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//
//class AddressBook extends StatefulWidget {
//  String userPhoneNo;
//
//  AddressBook({@required this.userPhoneNo});
//
//  @override
//  _AddressBookState createState() => _AddressBookState(userPhoneNo: userPhoneNo);
//}
//
//class _AddressBookState extends State<AddressBook> {
//  String userPhoneNo;
//
//  _AddressBookState({@required this.userPhoneNo});
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: StreamBuilder(
//        stream: Firestore.instance.collection("usersLocation").document(userPhoneNo).snapshots(),
//        builder: (context, snapshot){
//          if(snapshot.data == null) return CircularProgressIndicator();//to avoid error - "getter document was called on null"
//          return ListView.separated(//to create the seperated view of each chat, has to be used with separatorBuilder: (context, index) => Divider
//            itemCount: snapshot.data.documents.length,
//            itemBuilder: (context, index){
//
//              return ListTile(//main widget that creates the message box
//                leading: SizedBox(
//                  width: 45,
//                  child: FutureBuilder(
//                    future: getFriendPhoneNo(conversationId),
//                    builder: (BuildContext context, AsyncSnapshot snapshot) {
//                      print("Dat $snapshot");
//                      if(snapshot.connectionState == ConnectionState.done) {
//                        return SideMenuState().getProfilePicture(
//                            friendNo);
//                      }
//                      return CircularProgressIndicator();
//                    },
//                  )
//                  ,
//                ),
//
////                  CircleAvatar(//profile picture
////                    radius: 35,
////                    //backgroundImage: SideMenuState().getProfilePicture(),
////                    //AssetImage(chats[index].sender.imageUrl)
////                  ),
//                title: Text(
//                  friendName,
//                  //chats[index].sender.name,
//                ),
//                subtitle: Text(
//                  lastMessage,
//                  //chats[index].text,
//                ),
//                //dense: true,
//                trailing: Text(//time
//                  DateFormat("dd MMM kk:mm")
//                      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp.millisecondsSinceEpoch.toString()))),
//                  style: TextStyle(
//                    fontSize: 12,
//                  ),
//                ),
//                onTap: (){
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => IndividualChat(friendName: friendName,conversationId: conversationId,userName:myName,userPhoneNo: myNumber,),//pass Name() here and pass Home()in name_screen
//                      )
//                  );
//                },
//              );
//            },
//            separatorBuilder: (context, index) => Divider(//to divide the chat list
//              color: Colors.white,
//            ),
//          );
//        },
//      ),
//    );
//  }
//}
