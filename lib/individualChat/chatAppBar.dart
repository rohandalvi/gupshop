import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/typing/typingStatusDisplay.dart';
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
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                /// back Arrow:
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: CustomIconButton(
                        iconNameInImageFolder: 'backArrowColor',
                        onPressed: backOnPressed,
                        iconsize: IconConfig.bigIcon,
                      ).resize(),
                    ),
                  ],
                ),

                /// Avatar:
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 18,left: 4, right: 5),
                      child: Container(
                        child: GestureDetector(
                          child: displayPictureAvatar,
                          onTap: avatarOnPressed,
                        ),
                      ),
                    ),
                  ],
                ),
                /// name, lastSeen and typing status:
                Column(
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              /// name:
                              Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: Container(
                                    child : GestureDetector(
                                      child: name,
                                      onTap: nameOnPressed,
                                    )
                                ),
                              ),
                              Container(
                                /// show presence only when its an individual conversation, not
                                /// in group conversation
                                child: Visibility(
                                  visible: presenceVisibility,
                                  child: presence,
                                ),
                              ),
                              /// typing :
                              Container(
                                  child: TypingStatusDisplay(
                                    conversationId: conversationId,
                                    userNumber: userPhoneNo,
                                    userName: userName,
                                    groupExits: groupExits,),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            /// video audio call icons:
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomIconButton(
                          iconNameInImageFolder: 'videoCall',
                          onPressed: (){},
                        ),
                        CustomIconButton(
                          iconNameInImageFolder: 'audioCall',
                          onPressed: (){},
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
