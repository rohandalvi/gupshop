import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToChangeProfilePicture.dart';
import 'package:gupshop/passcode/setPasscode.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/contactSearch/contactSearchPage.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/image/displayAvatar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class HomeAppBar extends StatelessWidget {
  final String userPhoneNo;
  final String userName;
  double radius;
  double innerRadius;

  HomeAppBar({@required this.userPhoneNo, @required this.userName}) :
        radius = ImageConfig.radius,/// 30
        innerRadius = ImageConfig.innerRadius;///25;



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(/// Area - 3
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child:
//            Padding(/// Area - 2
//              padding: EdgeInsets.only(top: PaddingConfig.eight),
//              child: Container(
            Container(
                child: Row(/// Area - 5
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    /// Avatar:
                    Expanded(
                      flex: 1,
//                    child: Padding(
//                      padding: EdgeInsets.only(top: PaddingConfig.twentyThree,left: PaddingConfig.seven, right: PaddingConfig.five),
                        child: Container(
                          child: Padding(
                            //padding: EdgeInsets.only(top: PaddingConfig.twentyThree,left: PaddingConfig.seven, right: PaddingConfig.five),
                            padding: EdgeInsets.only(left: PaddingConfig.seven,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  child: DisplayAvatar().displayAvatarFromFirebase(userPhoneNo, radius, innerRadius, false),
                                  onTap: (){
                                    NavigateChangeProfilePicture(
                                        userName: userName,
                                        viewingFriendsProfile: false,
                                        userPhoneNo: userPhoneNo,
                                        groupConversationId: null,
                                    ).navigateNoBrackets(context);
                                    //CustomNavigator().navigateToChangeProfilePicture(context, userName, false, userPhoneNo, null);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
//                    ),
                    ),

                    /// create group and search icons:
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Flexible(
                              flex : 1,
                              child: FutureBuilder(
                                future: UserDetails().getPasscodeStatus(),
                                builder: (context, snapshot) {
                                  if(snapshot.connectionState == ConnectionState.done){
                                    bool enabled = snapshot.data;
                                    String icon;
                                    if(enabled == true) icon = IconConfig.unlock;
                                    else icon = IconConfig.lock;

                                    return CustomIconButton(
                                      iconNameInImageFolder: icon,
                                      onPressed: (){
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation, secondaryAnimation) => SetPasscode(),
                                          ),
                                        );
                                      },
                                    );
                                  } return CustomIconButton(
                                    iconNameInImageFolder: IconConfig.lock,
                                  );
                                }
                              ),
                            ),
                            /// create group
                            Flexible(
                              flex: 1,
                              child: CustomIconButton(
                                iconNameInImageFolder: IconConfig.groupIcon,
                                onPressed: (){
                                  CustomNavigator().navigateToCreateGroup(context, userName, userPhoneNo, false, null);
                                },
                              ),
                            ),
                            /// search icon
                            Flexible(
                              flex: 1,
                              child: Builder(
                                builder: (context) => CustomIconButton(//Right side icons
                                  iconNameInImageFolder: 'advancedSearch',//search icon
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ContactSearchPage(userPhoneNo: userPhoneNo, userName: userName),//pass Name() here and pass Home()in name_screen
                                        )
                                    );
                                  },//imp for pressing effect. Also gives a sound effect by default
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
//            ),
          ),
          ///Tabs:
          Expanded(
            flex: 1,
            child: TabBar(/// Area - 2
              tabs: <Widget>[
                Tab(child: CustomText(text: 'Chats',),),
                Tab(child: CustomText(text: 'Bazaar',),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:gupshop/modules/userDetails.dart';
//import 'package:gupshop/responsive/sizeConfig.dart';
//import 'package:gupshop/screens/contactSearchPage.dart';
//import 'package:gupshop/widgets/customNavigators.dart';
//import 'package:gupshop/image/displayAvatar.dart';
//import 'package:gupshop/widgets/customIconButton.dart';
//import 'package:gupshop/widgets/customText.dart';
//
//class HomeAppBar extends StatefulWidget {
//  final String userPhoneNo;
//  final String userName;
//  double radius;
//  double innerRadius;
//
//  HomeAppBar({@required this.userPhoneNo, @required this.userName}) :
//        radius = SizeConfig.imageSizeMultiplier * 7,/// 30
//        innerRadius = SizeConfig.imageSizeMultiplier * 6.25;///25;
//
//  @override
//  _HomeAppBarState createState() => _HomeAppBarState(userName: userName, userPhoneNo: userPhoneNo);
//}
//
//class _HomeAppBarState extends State<HomeAppBar> {
//  final String userPhoneNo;
//  final String userName;
//
//  _HomeAppBarState({@required this.userPhoneNo, @required this.userName});
//
//  ImageProvider userAvatar;
//
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//      return AppBar(
//       // backgroundColor: Colors.white,
//        leading: Container(
//          //borderRadius: BorderRadius.circular(25.0),
//          width: 100,
//          child: Align(
//            //alignment: Alignment.center,
//            child: GestureDetector(
//              onTap: (){
//                CustomNavigator().navigateToChangeProfilePicture(context, userName, false, userPhoneNo, null);
//              },
//              child: DisplayAvatar().displayAvatarFromFirebase(userPhoneNo, widget.radius, widget.innerRadius, false),
//            ),
//          ),
//        ),
//        actions: <Widget>[
//          FutureBuilder(
//            future: UserDetails().getIsBazaarWalaInSharedPreferences(),
//            builder: (BuildContext context, AsyncSnapshot snapshot) {
//              if (snapshot.connectionState == ConnectionState.done) {
//                bool isBazaarWala = snapshot.data;
//                if(isBazaarWala == null) isBazaarWala = false;/// if the user is not bazaarWala then isBazaarWala returns as null giving us an error
//                return Visibility(
//                  visible: isBazaarWala,
//                  child: CustomIconButton(
//                    onPressed: NavigateToSelectCategoryToShowInProductDetailsPage(productWalaNumber: userPhoneNo, productWalaName: userName).navigate(context),
//                    iconNameInImageFolder: 'bazaar',),
//                );
//              }
//              return Center(
//                child: CircularProgressIndicator(),
//              );
//            },
//          ),
//          CustomIconButton(
//            iconNameInImageFolder: 'groupManWoman',
//            onPressed: (){
//              CustomNavigator().navigateToCreateGroup(context, userName, userPhoneNo, false, null);
//            },
//          ),
//          Builder(
//            builder: (context) => CustomIconButton(//Right side icons
//              iconNameInImageFolder: 'advancedSearch',//search icon
//              onPressed: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => ContactSearchPage(userPhoneNo: userPhoneNo, userName: userName),//pass Name() here and pass Home()in name_screen
//                    )
//                );
//              },//imp for pressing effect. Also gives a sound effect by default
//            ),
//          ),
//        ],
//        bottom: TabBar(
//          tabs: <Widget>[
//            Tab(child: CustomText(text: 'Chats',),),
//            Tab(child: CustomText(text: 'Bazaar',),),
//          ],
//        ),
//      );
//    }
//}
