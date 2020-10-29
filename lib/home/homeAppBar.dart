import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/passcode/setPasscode.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/contactSearch/contactSearchPage.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/image/displayAvatar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class HomeAppBar extends StatefulWidget {
  final String userPhoneNo;
  final String userName;
  double radius;
  double innerRadius;

  HomeAppBar({@required this.userPhoneNo, @required this.userName}) :
        radius = ImageConfig.radius,/// 30
        innerRadius = ImageConfig.innerRadius;
  @override
  _HomeAppBarState createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
///25;

  @override
  void initState() {
    print("AppLock state HomeAppBar initState: ${AppLock.of(context)}");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    print("AppLock state HomeAppBar: ${AppLock.of(context)}");
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
                                  child: DisplayAvatar().displayAvatarFromFirebase(widget.userPhoneNo, widget.radius, widget.innerRadius, false),
                                  onTap: (){
                                    Map<String,dynamic> navigatorMap = new Map();
                                    navigatorMap[TextConfig.userName] = widget.userName;
                                    navigatorMap[TextConfig.viewingFriendsProfile] = false;
                                    navigatorMap[TextConfig.userPhoneNo] = widget.userPhoneNo;
                                    navigatorMap[TextConfig.groupConversationId] = null;

                                    Navigator.pushNamed(context, NavigatorConfig.changeProfilePicture, arguments: navigatorMap);
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
                              child: CustomIconButton(
                                iconNameInImageFolder: IconConfig.lock,
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => SetPasscode(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            /// create group
                            Flexible(
                              flex: 1,
                              child: CustomIconButton(
                                iconNameInImageFolder: IconConfig.groupIcon,
                                onPressed: (){
                                  Map<String,dynamic> navigatorMap = new Map();
                                  navigatorMap[TextConfig.userPhoneNo] = widget.userPhoneNo;
                                  navigatorMap[TextConfig.userName] = widget.userName;
                                  navigatorMap[TextConfig.shouldAddNewGroupMember] = false;
                                  navigatorMap[TextConfig.conversationId] = null;

                                  Navigator.pushNamed(context, NavigatorConfig.createGroup, arguments: navigatorMap);
                                  //CustomNavigator().navigateToCreateGroup(context, widget.userName, widget.userPhoneNo, false, null);
                                },
                              ),
                            ),
                            /// search icon
                            Flexible(
                              flex: 1,
                              child: Builder(
                                builder: (context) => CustomIconButton(//Right side icons
                                  iconNameInImageFolder: IconConfig.searchTwo,//search icon
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ContactSearchPage(userPhoneNo: widget.userPhoneNo, userName: widget.userName),//pass Name() here and pass Home()in name_screen
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
  }}
