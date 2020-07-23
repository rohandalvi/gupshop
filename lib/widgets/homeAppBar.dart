//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/screens/contactSearchPage.dart';
import 'package:gupshop/service/contact_search.dart';
import 'package:gupshop/service/createFriendsCollection.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/service/displayAvatarFromFirebase.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/verticalPadding.dart';
import 'package:flutter_svg/svg.dart';

class HomeAppBar extends StatefulWidget {
  final String userPhoneNo;
  final String userName;

  HomeAppBar({@required this.userPhoneNo, @required this.userName});

  @override
  _HomeAppBarState createState() => _HomeAppBarState(userName: userName, userPhoneNo: userPhoneNo);
}

class _HomeAppBarState extends State<HomeAppBar> {
  final String userPhoneNo;
  final String userName;

  _HomeAppBarState({@required this.userPhoneNo, @required this.userName});

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
        leading: Container(
          //borderRadius: BorderRadius.circular(25.0),
          width: 100,
          child: Align(
            //alignment: Alignment.center,
            child: GestureDetector(
              onTap: (){
                CustomNavigator().navigateToChangeProfilePicture(context, userName, false, userPhoneNo, null);
              },
              child: DisplayAvatarFromFirebase().displayAvatarFromFirebase(userPhoneNo, 30, 25, false),
            ),
          ),
        ),
       
//        title: CustomRaisedButton(
//          onPressed: (){
//            CreateFriendsCollection(userName: userName, userPhoneNo: userPhoneNo,).getUnionContacts();
//          },
//          child: CustomText(text: 'Refresh new contacts',),
//        ),
        actions: <Widget>[
          FutureBuilder(
            future: UserDetails().getIsBazaarWalaInSharedPreferences(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                bool isBazaarWala = snapshot.data;
                if(isBazaarWala == null) isBazaarWala = false;/// if the user is not bazaarWala then isBazaarWala returns as null giving us an error
                print("isBazaarWala: $isBazaarWala");
                return Visibility(
                  visible: isBazaarWala,
                  child: CustomIconButton(
                    onPressed: NavigateToSelectCategoryToShowInProductDetailsPage(productWalaNumber: userPhoneNo, productWalaName: userName).navigate(context),
                    iconNameInImageFolder: 'bazaar',),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          IconButton(
            icon: SvgPicture.asset('images/groupManWoman.svg',),
            onPressed: (){
              CustomNavigator().navigateToCreateGroup(context, userName, userPhoneNo, false, null);
            },
          ),
          Builder(
            builder: (context) => IconButton(//Right side icons
              color: Colors.black,
              icon: SvgPicture.asset('images/advancedSearch.svg',),//search icon
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactSearchPage(userPhoneNo: userPhoneNo, userName: userName),//pass Name() here and pass Home()in name_screen
//                      builder: (context) => ContactSearch(userPhoneNo: userPhoneNo, userName: userName),//pass Name() here and pass Home()in name_screen
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
