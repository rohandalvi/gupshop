import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/widgets/customText.dart';


class CustomFutureBuilder extends StatelessWidget {
  final Future future;
  final dynamic dataReadyWidgetType;
  final Widget inProgressWidget;

  CustomFutureBuilder({@required this.future, @required this.dataReadyWidgetType, @required this.inProgressWidget});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {

          print("Snapshot ${snapshot.data}");
          switch(dataReadyWidgetType) {
            case CustomText: return new CustomText(text: snapshot.data!=null ? snapshot.data : "").subTitle(); //TODO - change this text message to actual snapshot.data;
            default: throw new Exception("Widget type not supported by this custom future builder");
          }
        }
        return inProgressWidget;
      }
    );
  }
}

class CustomFutureBuilderForGetIsBazaarWala extends StatelessWidget {
  Widget createIcon;
  Widget editIcon;

  CustomFutureBuilderForGetIsBazaarWala({@required this.createIcon, this.editIcon});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: UserDetails().getIsBazaarWalaInSharedPreferences(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            bool isBazaarWala = snapshot.data;
            print("isBazaarWala in CustomFutureBuilderForGetIsBazaarWala: $isBazaarWala");
            return isBazaarWala == true ? editIcon : createIcon;
          }
          return CircularProgressIndicator();
        }
    );
  }
}


//class CustomerFutureBuilder extends State{
//  FutureBuilder getFutureBuilder(Future future, Function builder) {
//    return FutureBuilder(
//      future: future,
//      builder: builder,
//    );
//  }
//}