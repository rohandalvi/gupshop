import 'package:flutter/cupertino.dart';
import 'package:gupshop/notifications/NotificationsManager.dart';
import 'package:gupshop/notifications/application/individualChatNotifier.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/customFlushBar.dart';

class Notifier{

  foreGround({BuildContext customContext,String currentConversationId, List<dynamic> currentChatWithNumber }){
    print("in foreGround");
    return new NotificationsManager(
        onMessage: (Map<String, dynamic> message) async {
          print("in onMessage");
          String notificationFromNumberIndividual = message[TextConfig.notificationFromNumberIndividual];
          String notificationFromName = message[TextConfig.notificationFromName];
          List<dynamic> notificationFromNumber = message[TextConfig.notificationFromNumber];
          String notifierConversationId = message[TextConfig.notifierConversationId];
          var data = message[TextConfig.messageBody];

          notificationBar(
              onTap: (){
                if(message[TextConfig.type] == TextConfig.IndividualChatType) {
                  return IndividualChatNotifier()
                      .foreGroundHandler(
                      notificationFromName: notificationFromName,
                      notificationFromNumber: notificationFromNumber,
                      notificationFromNumberIndividual: notificationFromNumberIndividual,
                      notifierConversationId: notifierConversationId,
                      customContext: customContext,
                      data: data,
                      currentConversationId: currentConversationId,
                      currentChatWithNumber: currentChatWithNumber
                  );
                }

                if(message[TextConfig.type] == TextConfig.videoChatType){

                }

                if(message[TextConfig.type] == TextConfig.audioChatType){

                }
              }
          );
        },

        onResume: (Map<String, dynamic> message){

        }
    );
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


  notificationBar({final GestureTapCallback onTap, BuildContext customContext}){
    return GestureDetector(
        child: CustomFlushBar(customContext: customContext,iconName: IconConfig.appIcon,).showTopFlushBar(),
        onTap: onTap,
    );
  }
}