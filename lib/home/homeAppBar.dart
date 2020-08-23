import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/screens/contactSearchPage.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                /// Avatar:
                Padding(
                  padding: const EdgeInsets.only(top: 23,left: 7, right: 5),
                  child: Container(
                    child: GestureDetector(
                      child: DisplayAvatar().displayAvatarFromFirebase(userPhoneNo, radius, innerRadius, false),
                      onTap: (){
                        CustomNavigator().navigateToChangeProfilePicture(context, userName, false, userPhoneNo, null);
                      },
                    ),
                  ),
                ),

                /// create group and search icons:
                Container(
                  child: Row(
                    children: <Widget>[
                      /// create group
                      CustomIconButton(
                        iconNameInImageFolder: 'groupManWoman',
                        onPressed: (){
                          CustomNavigator().navigateToCreateGroup(context, userName, userPhoneNo, false, null);
                        },
                      ),
                      /// search icon
                      Builder(
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ///Tabs:
        TabBar(
          tabs: <Widget>[
            Tab(child: CustomText(text: 'Chats',),),
            Tab(child: CustomText(text: 'Bazaar',),),
          ],
        ),
      ],
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
