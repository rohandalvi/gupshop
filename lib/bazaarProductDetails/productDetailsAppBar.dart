import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaarProductDetails/chatWithBazaarwala.dart';
import 'package:gupshop/navigators/navigateToChangeName.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class ProductDetailsAppBar extends StatelessWidget {
  final String productWalaName;
  final String productWalaNumber;
  final String userName;
  final bool sendHome;

  ProductDetailsAppBar({this.productWalaName, this.userName,
    this.productWalaNumber, this.sendHome});

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
        title: CustomText(text: productWalaName,),
        actions: <Widget>[
          /// change bazaarwala name:
          editName(context),

          /// chat bubble:
          ChatWithBazaarwala(
            bazaarwalaNumber: productWalaNumber,
            bazaarwalaName: productWalaName,
            userName: userName,
            customContext:context,
          ),
        ],
        onPressed: (){
          if(sendHome == true){
            NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
          }else {
            Navigator.pop(context);
          }
        }
    );
  }

  editName(BuildContext context){
    return CustomIconButton(
      iconNameInImageFolder: IconConfig.editIcon,
      onPressed: NavigateToChangeName().navigate(context),
    );
  }
}
