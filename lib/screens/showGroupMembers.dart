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
      child: FutureBuilder(
          future: UserDetails().getUserNameFuture(),
        builder: (context, nameSnapshot) {
          if (nameSnapshot.connectionState == ConnectionState.done) {
            userName = nameSnapshot.data;
            return ContainerForDialogBox(
              child: FutureBuilder(
                future: GetGroupMemberNames().getMapOfNameAndNumbers(widget.userNumber, widget.listOfGroupMemberNumbers, userName, widget.conversationId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return _showGroupMemberNames(snapshot.data, context); //ToDo- check is false is right here
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            );
          }return Center(
            child: CircularProgressIndicator(),
          );
        }
      )
    );
  }

  _showGroupMemberNames(Map<dynamic, String> groupMemberNameAndNumbers, BuildContext context){
    return Stack(
      children: <Widget>[
        Visibility(/// exit from group, user exits self
          visible: widget.isGroup,
          child: GestureDetector(
            onTap:  (){
              if(widget.isGroup == true){
                DeleteMembersFromGroup().deleteAGroupMember(widget.userNumber, widget.conversationId);
                setState(() {
                  bool removed = widget.listOfGroupMemberNumbers.remove(widget.userNumber);
                });
              }
            },
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 100,/// to increase the size of floatingActionButton use container along with FittedBox
                width: 100,
                child: FittedBox(
                  child: CustomFloatingActionButton(
                    child: IconButton(
                      icon: SvgPicture.asset('images/exit.svg',),
                      onPressed: () async{
                        userName = await UserDetails().getUserNameFuture();
                        CustomNavigator().navigateToCreateGroup(context, userName, widget.userNumber, true, widget.conversationId);
                      },
                      //SvgPicture.asset('images/downChevron.svg',)
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        ListView.builder(
            itemCount: groupMemberNameAndNumbers.length,
            itemBuilder: (BuildContext context, int index) {
              if(groupMemberNameAndNumbers == null) return CircularProgressIndicator();
              String name = groupMemberNameAndNumbers.keys.elementAt(index);///name of the member
              bool isVisible = false;

              /// if (admin => number and name => number is same) &&
              /// (name(purva,rohan,admin) should not be 'admin') because in map admin => number is also a key value pair
              /// so, in order to not display title('admin') and subtitle(number) in UI, we check
              /// that the key is not 'admin'
              if((name != 'admin') && (groupMemberNameAndNumbers['admin'] == groupMemberNameAndNumbers[name])){
                isVisible = true;

              }
              return ListTile(
                title: GestureDetector( /// removing else from group
                  onTap:  (){
                    if(widget.isGroup == true){
                      /// delete from conversationMetadata
                      DeleteMembersFromGroup().deleteAGroupMember(groupMemberNameAndNumbers[name], widget.conversationId);
                      /// delete from user's friend collection
                      DeleteMembersFromGroup().deleteFromFriendsCollection(groupMemberNameAndNumbers[name], widget.conversationId);
                      setState(() {
                        bool removed = widget.listOfGroupMemberNumbers.remove(groupMemberNameAndNumbers[name]);
                      });
                    }
                  },
                    child: name != 'admin' ? CustomText(text:name) : CustomText(text: '',)///name
                ),
                subtitle:Visibility(
                  visible: isVisible,
                  child: CustomText(text: 'admin',).subTitle(),
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
