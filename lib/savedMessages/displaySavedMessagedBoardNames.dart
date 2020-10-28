import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToABoard.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/clickableText.dart';
import 'package:gupshop/widgets/customText.dart';

class DisplaySavedMessagesBoardNames extends StatefulWidget {
  @override
  _DisplaySavedMessagesBoardNamesState createState() => _DisplaySavedMessagesBoardNamesState();
}

class _DisplaySavedMessagesBoardNamesState extends State<DisplaySavedMessagesBoardNames> {
  String userNumber;

  getUserName() async{
    userNumber = await UserDetails().getUserPhoneNoFuture();
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection("savedMessageBoard").document(userNumber).snapshots(),
          builder: (context, snapshot) {

            if(snapshot.data == null) return CircularProgressIndicator();
            print("snapshot.data : ${snapshot.data.data}");
            int numberOfBoards = snapshot.data.data.length;
            print("number of boards : $numberOfBoards");

            return ListView.separated(
              itemCount: numberOfBoards,
              itemBuilder: (context, index){
                String boardName = snapshot.data.data[index];

                if(numberOfBoards == 0){
                  return Center(child: CustomText(text: "No messages saved",));
                } return ClickableText(text: boardName, onTap: (){
                  Map<String,dynamic> navigatorMap = new Map();
                  navigatorMap[TextConfig.boardName] = boardName;

                  Navigator.pushNamed(context, NavigatorConfig.boardRoute, arguments:navigatorMap );
//                    NavigateToABoard(boardName: boardName).navigate(context);
                },);
              },
              separatorBuilder: (context, index) =>
                Divider( //to divide the chat list
                  color: Colors.white,
                ),
            );
          }
      ),
    );
  }
}
