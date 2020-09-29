import 'package:flutter/cupertino.dart';
import 'package:gupshop/notifications/NotificationsManager.dart';
import 'package:gupshop/notifications/application/individualChatNotifier.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customShowDialog.dart';
import 'package:gupshop/widgets/customText.dart';

class Notifier{

  foreGround({BuildContext customContext,String currentConversationId, List<dynamic> currentChatWithNumber,String userName, String userNumber }){
    print("in foreGround");

    NotificationsManager notificationsManager = new NotificationsManager(
        onMessage: (Map<String, dynamic> message) {
          print("in onMessage : ${message[TextConfig.payLoadNotification]}");

          String title = message[TextConfig.payLoadNotification][TextConfig.payLoadTitle];
          String body = message[TextConfig.payLoadNotification][TextConfig.payLoadBody];
          String notificationFromNumberIndividual = message[TextConfig.payLoadData][TextConfig.notificationFromNumberIndividual];
          String notificationFromName = message[TextConfig.payLoadData][TextConfig.notificationFromName];
          List<dynamic> notificationFromNumber = message[TextConfig.payLoadData][TextConfig.notificationFromNumber];
          String notifierConversationId = message[TextConfig.payLoadData][TextConfig.notifierConversationId];
          //var data = message[TextConfig.messageBody];

          return CustomShowDialog(
            actions: <Widget>[
              CupertinoDialogAction(
                  child: Text('Read'),
                  onPressed: () {
                    if(message[TextConfig.type] == TextConfig.IndividualChatType) {
                      return IndividualChatNotifier()
                          .forGroundHandlerHelper(
                        notificationFromName: notificationFromName,
                        notificationFromNumber: notificationFromNumber,
                        notificationFromNumberIndividual: notificationFromNumberIndividual,
                        notifierConversationId: notifierConversationId,
                        context: customContext,
                        //data: data,
                        currentConversationId: currentConversationId,
                        currentChatWithNumber: currentChatWithNumber,
                        userNumber: userNumber,
                        userName: userName,
                      );
                    }

                    if(message[TextConfig.type] == TextConfig.videoChatType){

                    }

                    if(message[TextConfig.type] == TextConfig.audioChatType){

                    }
                  }
              ),
            ],
          ).main(customContext, title);

//          CustomShowDialog(
//            customContext: customContext,
//            iconName: IconConfig.appIcon,
//            text: CustomText(text: title,),
//            onTap: (v){
//              if(message[TextConfig.type] == TextConfig.IndividualChatType) {
//                return IndividualChatNotifier()
//                    .forGroundHandlerHelper(
//                  notificationFromName: notificationFromName,
//                  notificationFromNumber: notificationFromNumber,
//                  notificationFromNumberIndividual: notificationFromNumberIndividual,
//                  notifierConversationId: notifierConversationId,
//                  context: customContext,
//                  //data: data,
//                  currentConversationId: currentConversationId,
//                  currentChatWithNumber: currentChatWithNumber,
//                  userNumber: userNumber,
//                  userName: userName,
//                );
//              }
//
//              if(message[TextConfig.type] == TextConfig.videoChatType){
//
//              }
//
//              if(message[TextConfig.type] == TextConfig.audioChatType){
//
//              }
//            },
//          ).showTopFlushBar();
        },

        onResume: (Map<String, dynamic> message){

        }
    );

    return notificationsManager;
  }

  terminated({dynamic appTerminatedHandler}){
    return new NotificationsManager(
        onLaunch: (Map<String, dynamic> message) async {
          return appTerminatedHandler;
    });
  }


  resume({dynamic resumeHandler}){
    return new NotificationsManager(
        onResume: (Map<String, dynamic> message) async {
          return resumeHandler;
        });
  }


//  notificationBar({final GestureTapCallback onTap, BuildContext customContext}){
//    return GestureDetector(
//        child:
//        onTap: onTap,
//    );
//  }
}