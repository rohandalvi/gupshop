import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /// back Arrow:
            Container(
                child : Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: CustomIconButton(
                        iconNameInImageFolder: 'backArrowColor',
                        onPressed: backOnPressed,
                        iconsize: 40,
                      ).resize(),
                    ),

                    /// Avatar:
                    Padding(
                      padding: const EdgeInsets.only(top: 20,left: 4, right: 5),
                      child: Container(
                        child: GestureDetector(
                          child: displayPictureAvatar,
                          onTap: avatarOnPressed,
                        ),
                      ),
                    ),
                    /// lastSeen and typing status:
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            /// name:
                            Container(
                                child : GestureDetector(
                                  child: name,
                                  onTap: nameOnPressed,
                                )
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
                            Container(child: TypingStatusDisplay(conversationId: conversationId, userNumber: userPhoneNo,userName:
                            userName,groupExits: groupExits,)),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
            ),

            /// video audio call icons:
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
      ),
    );
  }
}