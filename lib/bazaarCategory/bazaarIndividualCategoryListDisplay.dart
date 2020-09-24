import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarProductDetails/likesDislikesFetchAndDisplay.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToProductDetailPage.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/getFromFriendsCollection.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/widgets/customText.dart';

class BazaarIndividualCategoryListDisplay extends StatelessWidget {
  final String bazaarWalaName;
  final String category;
  final String categoryData;
  final String bazaarWalaPhoneNo;
  final String thumbnailPicture;
  final String subCategory;
  final String subCategoryData;
  final String homeServiceText;
  final bool homeServiceBool;
  final bool showHomeServices;

  BazaarIndividualCategoryListDisplay({this.bazaarWalaPhoneNo, this.category,
    this.bazaarWalaName, this.thumbnailPicture, this.subCategory, this.subCategoryData,
    this.categoryData, this.homeServiceText, this.homeServiceBool, this.showHomeServices
  });

  @override
  Widget build(BuildContext context) {

     return Visibility(
       visible: visibility(),
       child: Padding(
         padding: EdgeInsets.all(PaddingConfig.eight),
         child: Row(/// area - 6
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
             Expanded(/// 5
               flex: 5,
               child: Container(/// area - 5
                 child: Row(
                   children: <Widget>[
                     Expanded(
                       flex: 1,
                       child: avatar(context),
                     ),

                     SizedBox(width: WidgetConfig.sizedBoxHeightTen,),
                     Expanded(
                       flex: 3,
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisSize: MainAxisSize.min,
                         children: <Widget>[
                           Flexible(
                             flex: 1,
                             fit: FlexFit.loose,
                             child: bazaarWalaNameWidget(context),
                           ),
                           Flexible(
                             flex: 1,
                             fit: FlexFit.loose,
                             child: speciality(),
                           ),
                           Flexible(
                             flex: 1,
                             fit: FlexFit.loose,
                             child: LikesDislikesFetchAndDisplay(productWalaNumber: bazaarWalaPhoneNo,
                               categoryData: categoryData,subCategoryData: subCategoryData,),
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ),
             Expanded(/// 1 (5+1 = 6)
               flex: 1,
               child: Column(
                 children: <Widget>[
                   chatBubbleWidget(context),
                   homeServiceContainer(),
                 ],
               ),
             ),
           ],
         ),
       ),
     );
  }

  visibility(){
    if(showHomeServices == true && homeServiceBool == true) return true;
    if(showHomeServices == null) return true;
    if(showHomeServices == false) return true;
    if(showHomeServices == true && homeServiceBool == false) return false;
  }


  avatar(BuildContext context){
    return GestureDetector(
      onTap: (){
        NavigateToProductDetailPage(
          bazaarWalaPhoneNo: bazaarWalaPhoneNo,
          categoryData: categoryData,
          category: category,
          bazaarWalaName: bazaarWalaName,
          subCategory: subCategory,
          subCategoryData: subCategoryData,
          homeServiceBool: homeServiceBool,
          homeServiceText: homeServiceText
        ).navigateNoBrackets(context);
      },
      child: Image(
        image:  NetworkImage(thumbnailPicture),
        fit: BoxFit.contain,
        height: ImageConfig.bazaarIndividualCategoryHeight,/// 75
        width: ImageConfig.bazaarIndividualCategoryWidth,/// 75
      ),
    );
  }

  bazaarWalaNameWidget(BuildContext context){
    return GestureDetector(
      onTap: (){
        NavigateToProductDetailPage(
          bazaarWalaPhoneNo: bazaarWalaPhoneNo,
          categoryData: categoryData,
          category: category,
          bazaarWalaName: bazaarWalaName,
          subCategory: subCategory,
          subCategoryData: subCategoryData,
          homeServiceBool: homeServiceBool,
          homeServiceText: homeServiceText
        ).navigateNoBrackets(context);
      },
      child: Container(
        child: CustomText(
          text: bazaarWalaName,
        ),
      ),
    );
  }

  speciality(){
    return Container(
      child: CustomText(
        text: subCategory,
      ).subTitle(),
    );
  }


  chatBubbleWidget(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Container(
//      width: IconConfig.bazaarIndividualCategoryChatBubble,
//      height: IconConfig.bazaarIndividualCategoryChatBubble,
        child: CustomIconButton(
          iconsize: IconConfig.smallIcon,
          iconNameInImageFolder: 'chatBubble',
          onPressed: () async{
            List<dynamic> listOfFriendsNumbers = new List();
            listOfFriendsNumbers.add(bazaarWalaPhoneNo);

            String userNumber = await UserDetails().getUserPhoneNoFuture();
            String userName = await UserDetails().getUserNameFuture();

            String conversationId = await GetFromFriendsCollection(userNumber: userNumber,friendNumber: bazaarWalaPhoneNo).getConversationId();
            //await GetConversationIdFromConversationMetadataCollection(userNumber: userNumber, friendNumber: bazaarWalaPhoneNo).getIndividualChatId();

            NavigateToIndividualChat(conversationId: conversationId, userPhoneNo: userNumber,
                listOfFriendsNumbers: listOfFriendsNumbers, friendName: bazaarWalaName,
                userName: userName).navigateNoBrackets(context);
          },
        ).resize(),
      ),
    );
  }


  homeServiceContainer(){
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: Visibility(
        visible: homeServiceText != null,
        child: Container(
//          width: IconConfig.bazaarIndividualCategoryChatBubble,
//          height: IconConfig.bazaarIndividualCategoryChatBubble,
          child: CustomIconButton(
            iconNameInImageFolder: homeIcon(),
            onPressed: (){},
            iconsize: IconConfig.smallIcon,
          ).resize(),
        ),
      ),
    );
  }

  homeIcon(){
    if(homeServiceBool == true) return 'home';
    if(homeServiceBool == false) return 'noHome';
    if(homeServiceBool == null) return null;
  }
}
