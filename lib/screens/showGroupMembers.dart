import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/service/addNewGroupMember.dart';
import 'package:gupshop/service/createGroup.dart';
import 'package:gupshop/service/customNavigators.dart';
import 'package:gupshop/service/deleteMembersFromGroup.dart';
import 'package:gupshop/service/getGroupMemberNames.dart';
import 'package:gupshop/widgets/customDialogBox.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customText.dart';

class ShowGroupMembers extends StatelessWidget {
  String userNumber;
  List<dynamic> listOfGroupMemberNumbers;
  String userName;
  String conversationId;
  bool isGroup;

  ShowGroupMembers({this.userNumber, this.listOfGroupMemberNumbers,  @required this.conversationId, this.isGroup});

  @override
  Widget build(BuildContext context) {
    return CustomDialogBox(
      child: ContainerForDialogBox(
        child: FutureBuilder(
          future: GetGroupMemberNames().getMapOfNameAndNumbers(userNumber, listOfGroupMemberNumbers),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print("snapshot.data: ${snapshot.data}");
              return _showGroupMemberNames(snapshot.data, context); //ToDo- check is false is right here
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      )
    );
  }



  _showGroupMemberNames(Map<dynamic, String> groupMemberNameAndNumbers, BuildContext context){
    print("groupMemberNameAndNumbers in _showGroup: $groupMemberNameAndNumbers");
    return Stack(
      children: <Widget>[
        ListView.builder(
            itemCount: groupMemberNameAndNumbers.length,
            itemBuilder: (BuildContext context, int index) {
              if(groupMemberNameAndNumbers == null) return CircularProgressIndicator();
              String key = groupMemberNameAndNumbers.keys.elementAt(index);
              return ListTile(
                title: GestureDetector(
                  onTap:  (){
                    if(isGroup == true){
                      DeleteMembersFromGroup().deleteAGroupMember(groupMemberNameAndNumbers[key], conversationId);
                    }
                  },
                    child: CustomText(text:key)
                ),
              );
            }
        ),
        Visibility(
          visible: isGroup,
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,/// to increase the size of floatingActionButton use container along with FittedBox
                width: 100,
                child: FittedBox(
                  child: CustomFloatingActionButton(
                    child: IconButton(
                        icon: SvgPicture.asset('images/add.svg',),
                      onPressed: () async{
                          userName = await UserDetails().getUserNameFuture();
                          CustomNavigator().navigateToCreateGroup(context, userName, userNumber, true, conversationId);
                      },
                      //SvgPicture.asset('images/downChevron.svg',)
                    ),
                  ),
                ),
              )
          ),
        ),
      ],
    );
  }

//  _showGroupMemberNames(List<dynamic> groupMemberNames, BuildContext context){
//    return Stack(
//      children: <Widget>[
//        ListView.builder(
//            itemCount: groupMemberNames.length,
//            itemBuilder: (BuildContext context, int index) {
//              if(groupMemberNames == null) return CircularProgressIndicator();
//              return ListTile(
//                title: GestureDetector(
//                    onTap:  (){
//                      if(isGroup == true){
//                        DeleteMembersFromGroup().deleteAGroupMember(numbers)
//                      }
//                    },
//                    child: CustomText(text:groupMemberNames[index])
//                ),
//              );
//            }
//        ),
//        Visibility(
//          visible: isGroup,
//          child: Align(
//              alignment: Alignment.bottomCenter,
//              child: Container(
//                height: 100,/// to increase the size of floatingActionButton use container along with FittedBox
//                width: 100,
//                child: FittedBox(
//                  child: CustomFloatingActionButton(
//                    child: IconButton(
//                      icon: SvgPicture.asset('images/add.svg',),
//                      onPressed: () async{
//                        userName = await UserDetails().getUserNameFuture();
//                        CustomNavigator().navigateToCreateGroup(context, userName, userNumber, true, conversationId);
//                      },
//                      //SvgPicture.asset('images/downChevron.svg',)
//                    ),
//                  ),
//                ),
//              )
//          ),
//        ),
//      ],
//    );
//  }

}
