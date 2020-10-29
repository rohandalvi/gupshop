import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gupshop/notifications/IRules.dart';
import 'package:gupshop/notifications/NotificationEventType.dart';
import 'package:gupshop/notifications/application/notificationConsumerMethods.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/location/usersLocation.dart';
import 'package:gupshop/widgets/CustomFutureBuilder.dart';
import 'package:gupshop/bazaarCategory/bazaarHomeGridView.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';

// home.dart =>
// => bazaarProfilePage
class BazaarHomeScreen extends StatefulWidget implements IRules{
  final String userPhoneNo;
  final String userName;

  BazaarHomeScreen({@required this.userPhoneNo, @required this.userName});

  @override
  _BazaarHomeScreenState createState() => _BazaarHomeScreenState(userPhoneNo: userPhoneNo, userName: userName);

  @override
  bool apply(NotificationEventType eventType, String conversationId) {
    /// here all notifications should be shown, so returning true
    /// Notification types:
    /// Video call
    /// text message
    return true;
  }
}

class _BazaarHomeScreenState extends State<BazaarHomeScreen> {

  final String userPhoneNo;
  final String userName;

  _BazaarHomeScreenState({@required this.userPhoneNo, @required this.userName});


  notificationInit(){
    NotificationConsumerMethods().notificationInit(
      runtimeType: this.widget.runtimeType,
      widget: this.widget,
      onSelectNotificationFromConsumer: onSelectNotification
    );
  }


  /// when the user taps the notification:
  Future<void> onSelectNotification(String payload) async{
    NotificationConsumerMethods(
      userName: widget.userName,
      userPhoneNo: widget.userPhoneNo,
      customContext: context
    ).onSelectNotification(payload);
  }



  @override
  void initState() {
    notificationInit();

    super.initState();

    UsersLocation().setUsersLocationToFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: WidgetConfig.sizedBoxHeightTwelve,),
          new BazaarHomeGridView(),
        ],
      ),
      floatingActionButton: CustomFutureBuilderForGetIsBazaarWala(
        createIcon: floatingActionButtonForNewBazaarwala(),
        editIcon: floatingActionButtonForEditBazaarwala(),
      ),
      //_floatingActionButtonForNewBazaarwala(),
    );
  }

  floatingActionButtonForNewBazaarwala(){
    return CustomBigFloatingActionButton(
      child: CustomIconButton(
          iconNameInImageFolder: IconConfig.add,
      ),
      onPressed:(){
        Navigator.pushNamed(context, NavigatorConfig.bazaarWelcome);
      }
    );
  }

  /// futureBuilder for show
  floatingActionButtonForEditBazaarwala(){
    return CustomBigFloatingActionButton(
        child: CustomIconButton(
          iconNameInImageFolder: IconConfig.editIcon,
        ),
        onPressed:(){
          Navigator.pushNamed(context, NavigatorConfig.bazaarWelcome);
        }
    );
  }
}

