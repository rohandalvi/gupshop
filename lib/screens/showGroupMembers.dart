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

class ShowGroupMembers extends StatefulWidget {
  String userNumber;
  List<dynamic> listOfGroupMemberNumbers;
  String conversationId;
  bool isGroup;

  ShowGroupMembers({this.userNumber, this.listOfGroupMemberNumbers,  @required this.conversationId, this.isGroup});

  @override
  _ShowGroupMembersState createState() => _ShowGroupMembersState();
}

class _ShowGroupMembersState extends State<ShowGroupMembers> {
  String userName;

  @override
  Widget build(BuildContext context) {
    return CustomDialogBox(
      child: ContainerForDialogBox(
        child: FutureBuilder(
          future: GetGroupMemberNames().getMapOfNameAndNumbers(widget.userNumber, widget.listOfGroupMemberNumbers),
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
                    if(widget.isGroup == true){
                      DeleteMembersFromGroup().deleteAGroupMember(groupMemberNameAndNumbers[key], widget.conversationId);
                      setState(() {
                        String removed = widget.listOfGroupMemberNumbers.removeAt(index);
                        print("removed : $removed");
                      });
                    }
                  },
                    child: CustomText(text:key)
                ),
              );
            }
        ),
        Visibility(
          visible: widget.isGroup,
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
                          CustomNavigator().navigateToCreateGroup(context, userName, widget.userNumber, true, widget.conversationId);
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
}
