//take permission from the user to access contacts
//after taking permission actually access contacts. we get a Iterable object
//Extract the contacts and their name from the iterable
//compare them with the users collection
//add to the friends_myNumber collection the contacts that match

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class FindFriends extends StatefulWidget {
  @override
  _FindFriendsState createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {

  PermissionStatus permissionStatus;

  @override
  void initState() {
    super.initState();
    //PermissionHandler()
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
