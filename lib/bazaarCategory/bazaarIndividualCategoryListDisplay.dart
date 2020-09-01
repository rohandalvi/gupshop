import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/likesDislikesFetchAndDisplay.dart';
import 'package:gupshop/bazaar/productDetail.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToProductDetailPage.dart';
import 'package:gupshop/responsive/iconConfig.dart';
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

  BazaarIndividualCategoryListDisplay({this.bazaarWalaPhoneNo, this.category,
    this.bazaarWalaName, this.thumbnailPicture, this.subCategory, this.subCategoryData,
    this.categoryData, this.homeServiceText
  });

  @override
  Widget build(BuildContext context) {
    print("categoryData in BazaarIndividualCategoryListDisplay : $categoryData");
    print("category in BazaarIndividualCategoryListDisplay: $category");
    return Stack(
      children: <Widget>[
        GestureDetector(//for navigation to Product detial page
          onTap: (){
            NavigateToProductDetailPage(
              bazaarWalaPhoneNo: bazaarWalaPhoneNo,
              category: category,
              categoryData: categoryData,
              bazaarWalaName: bazaarWalaName,
              subCategory: subCategory,
              subCategoryData: subCategoryData,
            ).navigateNoBrackets(context);
          },
          child: Container(//stack => container(Padding(Column(Row,text,star text, container))) and positioned[for profile pic]
            margin: EdgeInsets.fromLTRB(40,1,2,1),///(40,5,20,5)
            height: MediaQuery.of(context).size.height * 0.15,/// 0.2
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              /// bottom - making it less increases chat bubble
              padding: EdgeInsets.fromLTRB(100,2,2,1),//padding is added to move all i.e name,short description, rating and rupee to right to make room for the profile photo
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,//name,short description, ratings and rs all moves down a bit if this is removed
                crossAxisAlignment: CrossAxisAlignment.start,//alignment of ratings and  short description
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.start,//this is removed to decrease space between name and short description
                      children: <Widget>[
                        Container(
                          width:150,//to avoid overflow
                          child: CustomText(text:bazaarWalaName,),
                          //'loooooooooooooooooooooooooooooooooooooooooooooooooooooooooongdddoooooooooooooooooooooooooooooooooooooooooooooooooo' )

                        ),
                        Expanded(
                          child: Container(
                            width: IconConfig.bazaarIndividualCategoryChatBubble,
                            height: IconConfig.bazaarIndividualCategoryChatBubble,
                            child: CustomIconButton(
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomText(text: subCategory,).subTitle(),
                  homeServiceContainer(),
                  LikesDislikesFetchAndDisplay(productWalaNumber: bazaarWalaPhoneNo, category: category,subCategory: subCategory,),
                  //SizedBox(height: 5,),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left:25,//left top and bottom for alignment of profile photo wrt to container
          top: 25,
          bottom: 25,
          child: GestureDetector(//for navigation to Product detial page
            onTap: (){
                  NavigateToProductDetailPage(
                    bazaarWalaPhoneNo: bazaarWalaPhoneNo,
                    categoryData: categoryData,
                    category: category,
                    bazaarWalaName: bazaarWalaName,
                    subCategory: subCategory,
                    subCategoryData: subCategoryData,
                  ).navigateNoBrackets(context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                width: 110,///110,
                image: NetworkImage(thumbnailPicture),
                fit: BoxFit.contain,//to adjust the image with the container
              ),
            ),
          ),
        ),
      ],
    );
  }

  homeServiceContainer(){
    return Container(
      child: Row(
        children: <Widget>[
          CustomIconButton(
            iconNameInImageFolder: 'home',
            onPressed: (){},
            iconsize: IconConfig.smallIcon,
          ).resize(),
          CustomText(
            text: homeServiceText,
          ).subTitle()
        ],
      ),
    );
  }
}
