import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/responsive/sizeConfig.dart';
import 'package:gupshop/contactSearch/contactSearchPage.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/image/displayAvatar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:flutter_svg/svg.dart';

class HomeAppBarFinal extends StatelessWidget {
  final String userPhoneNo;
  final String userName;
  double radius;
  double innerRadius;

  HomeAppBarFinal({@required this.userPhoneNo, @required this.userName}) :
        radius = SizeConfig.imageSizeMultiplier * 7,/// 30
        innerRadius = SizeConfig.imageSizeMultiplier * 6.25;///25;



  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20,left: 4, right: 5),
                  child: Container(
                    child: GestureDetector(
                      child: DisplayAvatar().displayAvatarFromFirebase(userPhoneNo, radius, innerRadius, false),
                      onTap: (){
                        //CustomNavigator().navigateToChangeProfilePicture(context, userName, false, userPhoneNo, null);
                      },
                    ),
                  ),
                ),

                /// create group and search icons:
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
