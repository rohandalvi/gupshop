import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:gupshop/chat_list_page/chat_List.dart';
import 'package:gupshop/dataGathering/myTrace.dart';
import 'package:gupshop/modules/Presence.dart';
import 'package:gupshop/bazaar/bazaarHome_screen.dart';
import 'package:gupshop/home/homeAppBar.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';

// name screen => home
// home  => bazaarHomeScreen
class Home extends StatefulWidget{
  final String userPhoneNo;
  final String userName;
  List<String> phoneNumberList;
  Presence presence;
  final int initialIndex;
  Home({@required this.userPhoneNo, @required this.userName, @required this.phoneNumberList, this.initialIndex,});


  @override
  _HomeState createState() {
    presence = new Presence(this.userPhoneNo);
    return _HomeState(userPhoneNo: userPhoneNo, userName: userName, phoneNumberList: phoneNumberList);
  }
}

class _HomeState extends State<Home> {
  final String userPhoneNo;
  final String userName;
  List<String> phoneNumberList;

  _HomeState({@required this.userPhoneNo, @required this.userName,@required this.phoneNumberList });


  @override
  void initState() {
    print("AppLock state Home: ${AppLock.of(context)}");
    homeTrace();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 2,
        initialIndex: widget.initialIndex == null ? 0 : widget.initialIndex,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(WidgetConfig.appBarOneTwenty),//the distance between gupShop and tabBars
              child: HomeAppBar(userName: userName, userPhoneNo: userPhoneNo,),
          ),
          body: TabBarView(
            children: <Widget>[
              //Contacts(),
              ChatList(myNumber: userPhoneNo, myName: userName,),
              BazaarHomeScreen(userPhoneNo: userPhoneNo, userName: userName,),
              //Text('Calls',),
            ],
          ),
        ),
      ),
    );
  }

  homeTrace() async{
    int incrementBy = 1; /// correct ?

    MyTrace trace = new MyTrace(nameSpace: TextConfig.homeTrace);
    await trace.startTrace();
    await trace.metricIncrement(metricName: TextConfig.homeHit, incrementBy: incrementBy);
    await trace.stopTrace();
  }
}

