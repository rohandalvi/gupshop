import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';
import 'package:gupshop/bazaarCategory/homeServiceText.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/widgets/customDialogForConfirmation.dart';
import 'package:gupshop/widgets/customText.dart';

class SubcategoryCheckBoxUI extends StatefulWidget {
  DocumentSnapshot doc;
  Map<String, bool > map;
  Map<String, String> subCategoryMap;
  final String categoryData;
  bool isCategorySelected = false;

  SubcategoryCheckBoxUI({this.doc, this.map,this.subCategoryMap,this.categoryData, this.isCategorySelected});

  @override
  _SubcategoryCheckBoxUIState createState() => _SubcategoryCheckBoxUIState();
}

class _SubcategoryCheckBoxUIState extends State<SubcategoryCheckBoxUI> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CheckboxListTile(
          controlAffinity:ListTileControlAffinity.leading ,
          title:CustomText(text: widget.doc.data["name"]),
          activeColor: primaryColor,
          value: widget.map[widget.doc.data["name"]],/// if value of a key in map(a subcategory name) is false or true
          //list[index],/// at first all the values would be false
          onChanged: (bool val) async{
            setState((){
              widget.map[widget.doc.data["name"]] = val; /// setting the new value as selected by user
              widget.isCategorySelected = val;
            });

            String subCategoryData = widget.subCategoryMap[widget.doc.data["name"]];

            String isHomeServiceApplicable = HomeServiceText(categoryData:widget.categoryData,
                subCategoryData: subCategoryData).bazaarWalasdialogText();
            if(isHomeServiceApplicable != null){
              bool homeService = false;

              if(val == true){
                homeService = await homeServiceDialog(isHomeServiceApplicable);
              }
              pushToBazaarWalasBasicProfile(subCategoryData, homeService);
            }
          }
      ),
    );
  }

  homeServiceDialog(String homeServiceText) async{
    bool temp = await CustomDialogForConfirmation(
      /// from homeServiceText
      title: homeServiceText,
      content: "",
      barrierDismissible: false,
    ).dialog(context);
    return temp;
  }

  pushToBazaarWalasBasicProfile(String subCategoryData, bool homeService) async{
    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
    await PushToBazaarWalasBasicProfile(
      categoryData: widget.categoryData,
      subCategoryData: subCategoryData,
      userPhoneNo: userPhoneNo,
      homeService: homeService,
    ).pushHomeService();
  }
}
