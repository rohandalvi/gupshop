import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/typing/typingStatusDisplay.dart';
import 'package:gupshop/video_call/VideoCallEntryPoint.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class ChatAppBar extends StatelessWidget {
  final VoidCallback backOnPressed;
  final VoidCallback avatarOnPressed;
  Widget displayPictureAvatar;
  final VoidCallback nameOnPressed;
  Widget name;
  String conversationId;
  String userPhoneNo;
  String userName;
  bool groupExits;
  Widget presence;
  bool presenceVisibility;


  ChatAppBar({this.backOnPressed, this.avatarOnPressed, this.displayPictureAvatar,
    this.name, this.nameOnPressed, this.conversationId, this.userPhoneNo,
    this.userName, this.groupExits, this.presence, this.presenceVisibility
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
//      child: Padding(
//        padding: EdgeInsets.only(top: PaddingConfig.ten),
        child: Container(
          child: Row(/// Area 4
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Row(
                  children: <Widget>[
                    /// back Arrow:
                    Expanded(
                      flex : 2,
                      child: Column(
                        children: <Widget>[
//                          Padding(
//                            padding: EdgeInsets.only(top: PaddingConfig.twelve),
//                            child: CustomIconButton(
                              CustomIconButton(
                              iconNameInImageFolder: IconConfig.backArrow,
                              onPressed: backOnPressed,
                              iconsize: IconConfig.bigIcon,
                            ).resize(),
//                          ),
                        ],
                      ),
                    ),

                    /// Avatar:
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
//                          Padding(
//                            padding: EdgeInsets.only(top: PaddingConfig.eighteen,left: PaddingConfig.four, right: PaddingConfig.five),
//                            child: Container(
                              Container(
                                padding: EdgeInsets.only(top: PaddingConfig.individualChatAppBarTop,),
                                child: GestureDetector(
                                  child: displayPictureAvatar,
                                  onTap: avatarOnPressed,
                              ),
                            ),
//                          ),
                        ],
                      ),
                    ),
                    /// name, lastSeen and typing status:
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            //child: Padding(
                              //padding: EdgeInsets.all(PaddingConfig.three),
                            /// TODO: Priority 1 : Apply responsiveness to the name below
                              child: Container(
                                child: Expanded(
                                  child: Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      /// name:
                                      Expanded(
                                        flex : 1,
//                                        child: FittedBox(
//                                          fit: BoxFit.fitWidth,
//                                          alignment: Alignment.topLeft,
                                          child: Container(
                                              width: WidgetConfig.threeSixtyWidth,
                                              alignment: Alignment.topLeft,
                                              padding: EdgeInsets.only(top: PaddingConfig.individualChatAppBarTop),
                                              child : GestureDetector(
                                                child: name,
                                                onTap: nameOnPressed,
                                              )
                                          ),
//                                        ),
                                      ),
                                      /// Last seen:
                                      Flexible(
                                        flex: 1,
                                        child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                          child: Container(
                                            width: WidgetConfig.twoFiftyWidth,
                                            height: WidgetConfig.twentyHeight,
                                            /// show presence only when its an individual conversation, not
                                            /// in group conversation
                                            child: Visibility(
                                              visible: presenceVisibility,
                                              child: presence,
                                            ),
                                          ),
                                        ),
                                      ),
                                      /// typing :
                                      Flexible(
                                        flex: 1,
                                        fit: FlexFit.loose,
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: TypingStatusDisplay(
                                            conversationId: conversationId,
                                            userNumber: userPhoneNo,
                                            userName: userName,
                                            groupExits: groupExits,),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            //),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// video audio call icons:
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Padding(
                      //padding: EdgeInsets.all(PaddingConfig.ten),
                      Container(
                        child: Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(PaddingConfig.ten),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: CustomIconButton(
                                    iconNameInImageFolder: IconConfig.videoCall,
                                    onPressed: (){
                                      VideoCallEntryPoint().main(context, this.userPhoneNo);
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: CustomIconButton(
                                    iconNameInImageFolder: IconConfig.audioCall,
                                    onPressed: (){},
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    //),
                  ],
                ),
              ),
            ],
          ),
        ),
//      ),
    );
  }
}
