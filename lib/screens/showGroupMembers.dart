import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/screens/changeGroupName.dart';
import 'package:gupshop/service/addNewGroupMember.dart';
import 'package:gupshop/service/createGroup.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/deleteFromFirebase/deleteMembersFromGroup.dart';
import 'package:gupshop/service/getConversationDetails.dart';
import 'package:gupshop/service/getGroupMemberNames.dart';
import 'package:gupshop/widgets/customDialogBox.dart';
import 'package:gupshop/widgets/customDialogForConfirmation.dart';
import 'package:gupshop/widgets/customDismissible.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customTextFormField.dart';

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
                    return _showGroupMemberNames(snapshot.data, context);
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
    return Scaffold(

      /// Group name and exit button:
        appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,

            /// group name:
            title: FutureBuilder(
                future: GetConversationDetails().getGroupName(widget.conversationId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    String groupName = snapshot.data;
                    String newGroupName;
                    return CustomTextFormField(
                      onChanged:(val){
                        newGroupName= val;
                      },
                      onFieldSubmitted:(result){
                        print("in onFieldSubmitted");
                        setState(() {
                          groupName = newGroupName;
                        });
                        print("groupName: $groupName");
                        ChangeGroupName().changeName(widget.listOfGroupMemberNumbers, widget.conversationId, groupName);
                      } ,
                      onSaved:(change){
                        print("onchange");
                      },
                      initialValue: groupName,
                      labelText: 'Change group name',
                      //maxLength: 20,
                      enabledBorder: null,
                    );
                  }return Center(
                    child: CircularProgressIndicator(),
                  );
                }
            ),

            actions: <Widget>[
              /// exit button
              Visibility(/// exit icon, exit from group, user exits self
                visible: widget.isGroup,
                child: IconButton(
                  icon: SvgPicture.asset('images/exit.svg',),
                  onPressed: (){/// remove yourself from group
                    if(widget.isGroup == true){
                      DeleteMembersFromGroup().deleteAGroupMember(widget.userNumber, widget.conversationId);
                      DeleteMembersFromGroup().deleteFromFriendsCollection(widget.userNumber, widget.conversationId);
                      setState(() {
                        bool removed = widget.listOfGroupMemberNumbers.remove(widget.userNumber);
                      });
                    }
                  },
                ),
              ),
            ],
        ),

        /// names of members
        body: ListView.builder(/// displaying names of group members
            shrinkWrap: true,
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
              return Visibility(
                visible: name != 'admin',
                child: ListTile(
                  dense: true,
                  //contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                  title: InkWell(
                    onTap:  () async{/// if user is admin, remove other members from the group
                      String adminNumber = await GetConversationDetails().knowWhoIsAdmin(widget.conversationId);
                      if(widget.isGroup == true && adminNumber == widget.userNumber){
                        /// take a list for all the members to be deleted
                        /// pass ti deleteAGroupMember and deleteFromFriendsCollection in for each

                        /// show dialog to confirm the delete:
                        bool shouldDelete = await CustomDialogForConfirmation().dialog(context);

                        if(shouldDelete == true){
                          /// delete from conversationMetadata
                          DeleteMembersFromGroup().deleteAGroupMember(groupMemberNameAndNumbers[name], widget.conversationId);
                          /// delete from user's friend collection
                          DeleteMembersFromGroup().deleteFromFriendsCollection(groupMemberNameAndNumbers[name], widget.conversationId);
                          setState(() {
                            bool removed = widget.listOfGroupMemberNumbers.remove(groupMemberNameAndNumbers[name]);
                          });
                        }
                      }
                    },
                      child: CustomText(text:name)
                      //name != 'admin' ? CustomText(text:name) : CustomText(text: '',)///name
                  ),
                  subtitle:Visibility(
                    visible: isVisible,
                    child: CustomText(text: 'admin',).subTitle(),
                  ),
                ),
              );
            }
        ),

        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        /// add button
        bottomNavigationBar : FutureBuilder(
          future: GetConversationDetails().knowWhoIsAdmin(widget.conversationId),
          builder: (context, snapshot) {
            String adminNumber;
            if (snapshot.connectionState == ConnectionState.done) {
              adminNumber = snapshot.data;
              return Visibility(/// add members, visible only to admin
                visible: widget.isGroup && adminNumber == widget.userNumber,
                child: IconButton(
                  icon: SvgPicture.asset('images/add.svg',),
                  onPressed: () async{
                    userName = await UserDetails().getUserNameFuture();
                    CustomNavigator().navigateToCreateGroup(context, userName, widget.userNumber, true, widget.conversationId);
                  },
                  //SvgPicture.asset('images/downChevron.svg',)
                ),
              );
            }return Center(
              child: Container(),
            );

          }
        ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}

//return Stack(
//children: <Widget>[
//Visibility(/// exit icon, exit from group, user exits self
//visible: widget.isGroup,
//child: Align(
//alignment: Alignment.topRight,
//child: Container(
//height: 100,/// to increase the size of floatingActionButton use container along with FittedBox
//width: 100,
//child: FittedBox(
//child: CustomFloatingActionButton(
//child: IconButton(
//icon: SvgPicture.asset('images/exit.svg',),
//onPressed: (){/// remove yourself from group
//if(widget.isGroup == true){
//DeleteMembersFromGroup().deleteAGroupMember(widget.userNumber, widget.conversationId);
//DeleteMembersFromGroup().deleteFromFriendsCollection(widget.userNumber, widget.conversationId);
//setState(() {
//bool removed = widget.listOfGroupMemberNumbers.remove(widget.userNumber);
//});
//}
//},
//),
//),
//),
//),
//),
//),
//ListView.builder(/// displaying names of group members
//shrinkWrap: true,
//itemCount: groupMemberNameAndNumbers.length,
//itemBuilder: (BuildContext context, int index) {
//if(groupMemberNameAndNumbers == null) return CircularProgressIndicator();
//String name = groupMemberNameAndNumbers.keys.elementAt(index);///name of the member
//bool isVisible = false;
//
///// if (admin => number and name => number is same) &&
///// (name(purva,rohan,admin) should not be 'admin') because in map admin => number is also a key value pair
///// so, in order to not display title('admin') and subtitle(number) in UI, we check
///// that the key is not 'admin'
//if((name != 'admin') && (groupMemberNameAndNumbers['admin'] == groupMemberNameAndNumbers[name])){
//isVisible = true;
//}
//return Visibility(
//visible: name != 'admin',
//child: ListTile(
//dense: true,
////contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
//title: InkWell(
//onTap:  () async{/// if user is admin, remove other members from the group
//String adminNumber = await GetConversationDetails().knowWhoIsAdmin(widget.conversationId);
//if(widget.isGroup == true && adminNumber == widget.userNumber){
///// take a list for all the members to be deleted
///// pass ti deleteAGroupMember and deleteFromFriendsCollection in for each
//
///// show dialog to confirm the delete:
//bool shouldDelete = await CustomDialogForConfirmation().dialog(context);
//
//if(shouldDelete == true){
///// delete from conversationMetadata
//DeleteMembersFromGroup().deleteAGroupMember(groupMemberNameAndNumbers[name], widget.conversationId);
///// delete from user's friend collection
//DeleteMembersFromGroup().deleteFromFriendsCollection(groupMemberNameAndNumbers[name], widget.conversationId);
//setState(() {
//bool removed = widget.listOfGroupMemberNumbers.remove(groupMemberNameAndNumbers[name]);
//});
//}
//}
//},
//child: CustomText(text:name)
////name != 'admin' ? CustomText(text:name) : CustomText(text: '',)///name
//),
//subtitle:Visibility(
//visible: isVisible,
//child: CustomText(text: 'admin',).subTitle(),
//),
//),
//);
//}
//),
//FutureBuilder(
//future: GetConversationDetails().knowWhoIsAdmin(widget.conversationId),
//builder: (context, snapshot) {
//String adminNumber;
//if (snapshot.connectionState == ConnectionState.done) {
//adminNumber = snapshot.data;
//return Visibility(/// add members, visible only to admin
//visible: widget.isGroup && adminNumber == widget.userNumber,
//child: Align(
//alignment: Alignment.bottomCenter,
//child: Container(
//height: 100,/// to increase the size of floatingActionButton use container along with FittedBox
//width: 100,
//child: FittedBox(
//child: CustomFloatingActionButton(
//child: IconButton(
//icon: SvgPicture.asset('images/add.svg',),
//onPressed: () async{
//userName = await UserDetails().getUserNameFuture();
//CustomNavigator().navigateToCreateGroup(context, userName, widget.userNumber, true, widget.conversationId);
//},
////SvgPicture.asset('images/downChevron.svg',)
//),
//),
//),
//)
//),
//);
//}return Center(
//child: Container(),
//);
//
//}
//),
//],
//);
