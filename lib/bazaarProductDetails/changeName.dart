import 'package:flutter/cupertino.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/notifications/IRules.dart';
import 'package:gupshop/notifications/NotificationEventType.dart';
import 'package:gupshop/notifications/application/notificationConsumerMethods.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/WelcomeScreenWithTextField.dart';
import 'package:gupshop/widgets/customFlushBar.dart';

class ChangeName extends StatefulWidget implements IRules{
  String businessName;

  ChangeName({this.businessName});

  @override
  _ChangeNameState createState() => _ChangeNameState();

  @override
  bool apply(NotificationEventType notificationEventType, String conversationId) {
    return true;
  }
}

class _ChangeNameState extends State<ChangeName> {
  String tempBusinessName;

  /// navigator methods:
  notificationInit(){
    NotificationConsumerMethods().notificationInit(
        runtimeType: this.widget.runtimeType,
        widget: this.widget,
        onSelectNotificationFromConsumer: onSelectNotification
    );
  }


  /// when the user taps the notification:
  Future<void> onSelectNotification(String payload) async{
    String userName = await UserDetails().getUserNameFuture();
    String userNumber = await UserDetails().getUserPhoneNoFuture();

    NotificationConsumerMethods(
        userName: userName,
        userPhoneNo: userNumber,
        customContext: context
    ).onSelectNotification(payload);
  }


  @override
  void initState() {
    notificationInit();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WelcomeScreenWithTextField(
      onBackPressed: (){
        Navigator.pop(context);
      },
      labelText: TextConfig.bazaarChangeNameTextfieldLabel,
      bodyTitleText: TextConfig.bazaarChangeNameTextTitle,
      bodyImage: ImageConfig.bazaarChangeName,
      bodySubtitleText: TextConfig.bazaarChangeNameTextSubtitle,
      nextIcon: IconConfig.tickMarkIcon,
      nameOnChanged: (val){
        widget.businessName = val;
      },
      onNextPressed: (){
        print("businessName : ${widget.businessName}");
        if(widget.businessName == null || widget.businessName == ""){
          CustomFlushBar(
            customContext: context,
            message: TextConfig.bazaarChangeNameFlushbarMessage,
          ).showFlushBarStopHand();
        }

        if(widget.businessName != null && widget.businessName != ""){
          print("widget.businessName in not null : ${widget.businessName}");
          Navigator.pop(context, widget.businessName);

          /// Add Trace :
          //OnBoardingTrace().createNewUser();
        }
      },
    );
  }
}
