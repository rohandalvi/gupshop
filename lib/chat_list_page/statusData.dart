import 'package:flutter/cupertino.dart';
import 'package:gupshop/PushToFirebase/status.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/widgets/customIcon.dart';

class StatusData extends StatelessWidget {
  final String userPhoneNo;

  StatusData({this.userPhoneNo});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Status(userPhoneNo:userPhoneNo ).getIconName(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if(snapshot.hasData){
            String statusIcon = snapshot.data;
            return CustomIcon(iconName: statusIcon,).networkIcon(context);
          }return CustomIcon(iconName: IconConfig.free,);
        }
        return CustomIcon(iconName: IconConfig.free,);
      },
    );
  }
}
