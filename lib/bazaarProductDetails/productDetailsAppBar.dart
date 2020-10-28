import 'package:flutter/cupertino.dart';
import 'package:gupshop/bazaarProductDetails/chatWithBazaarwala.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/updateInFirebase/updateBazaarWalasBasicProfile.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class ProductDetailsAppBar extends StatefulWidget {
  String productWalaName;
  final String productWalaNumber;
  final String userName;
  final bool sendHome;
  final String businessName;

  /// for updating name to firebase
  final String categoryData;
  final String subCategoryData;
  final String userPhoneNo;

  ProductDetailsAppBar({this.productWalaName, this.userName,
    this.productWalaNumber, this.sendHome, this.businessName,
    this.userPhoneNo, this.categoryData, this.subCategoryData
  });

  @override
  _ProductDetailsAppBarState createState() => _ProductDetailsAppBarState();
}

class _ProductDetailsAppBarState extends State<ProductDetailsAppBar> {
  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
        title: CustomText(text: widget.productWalaName,),
        actions: <Widget>[
          /// change bazaarwala name:
          editName(context),

          /// chat bubble:
          ChatWithBazaarwala(
            bazaarwalaNumber: widget.productWalaNumber,
            bazaarwalaName: widget.productWalaName,
            userName: widget.userName,
            customContext:context,
          ),
        ],
        onPressed: (){
          if(widget.sendHome == true){
            Map<String,dynamic> navigatorMap = new Map();
            navigatorMap[TextConfig.initialIndex] = 1;
            navigatorMap[TextConfig.userPhoneNo] = widget.userPhoneNo;
            navigatorMap[TextConfig.userName] = widget.userName;

            Navigator.pushNamed(context, NavigatorConfig.home, arguments: navigatorMap);
          }else {
            Navigator.pop(context);
          }
        }
    );
  }

  editName(BuildContext context){

    return Visibility(
      visible: UserDetails().isBazaarwala(widget.userPhoneNo, widget.productWalaNumber),
      child: CustomIconButton(
        iconNameInImageFolder: IconConfig.editIcon,
        onPressed: () async {
          dynamic changedName = await Navigator.pushNamed(context, NavigatorConfig.changeName);
          //NavigateToChangeName().navigateNoBrackets(context);

          if(changedName != null && changedName != widget.businessName){
            /// push to firebase
            await UpdateBazaarWalasBasicProfile(
              categoryData:widget.categoryData,
              subCategoryData:widget.subCategoryData,
              userPhoneNo: widget.userPhoneNo,
            ).updateBusinessName(changedName);

            /// setState:
            setState(() {
              widget.productWalaName =  changedName;
            });
          }
        }
      ),
    );
  }
}
