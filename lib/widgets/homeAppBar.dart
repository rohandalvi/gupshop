import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/service/contact_search.dart';
import 'package:gupshop/service/displayAvatarFromFirebase.dart';
import 'package:gupshop/widgets/colorPalette.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/verticalPadding.dart';
import 'package:flutter_svg/svg.dart';

class HomeAppBar extends StatefulWidget {
  final String userPhoneNo;
  final String userName;

  HomeAppBar({@required this.userPhoneNo, @required this.userName});

  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {

  ImageProvider userAvatar;


  @override
  void initState() {
    //getUserAvatarFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      return AppBar(
       // backgroundColor: Colors.white,
        leading: Padding( 
          padding: EdgeInsets.all(2),
          child: DisplayAvatarFromFirebase().displayAvatarFromFirebase(widget.userPhoneNo, 35),),
       
        title: CustomText(text: 'GupShop', fontSize: 18,),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(//Right side icons
              color: Colors.black,
              icon: SvgPicture.asset('images/advancedSearch.svg',),//search icon
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactSearch(userPhoneNo: widget.userPhoneNo, userName: widget.userName),//pass Name() here and pass Home()in name_screen
                    )
                );
//                final result = await showSearch(
//                  context: context,
//                  delegate: ContactSearch(userPhoneNo: userPhoneNo, userName: userName),
//                );
//                Scaffold.of(context)
//                    .showSnackBar(SnackBar(content: Text(result),));
              },//imp for pressing effect. Also gives a sound effect by default
            ),
          ),
//          IconButton(
//            color: Colors.white,
//            icon: Icon(Icons.more_vert),//three dots
//            onPressed: () {
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => SideMenu(userName: userName),//pass Name() here and pass Home()in name_screen
//                  )
//              );
//            },
//          ),
        ],
        bottom: TabBar(
          tabs: <Widget>[
            Tab(child: CustomText(text: 'Chats',),),
            Tab(child: CustomText(text: 'Bazaar',),),
          ],
        ),
      );
    }
}