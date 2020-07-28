import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/likesDislikesFetchAndDisplay.dart';
import 'package:gupshop/bazaar/productDetail.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class BazaarIndividualCategoryListDisplay extends StatelessWidget {
  final String bazaarWalaName;
  final String category;
  final String bazaarWalaPhoneNo;

  BazaarIndividualCategoryListDisplay({this.bazaarWalaPhoneNo, this.category, this.bazaarWalaName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(//for navigation to Product detial page
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetail(
                    productWalaName: bazaarWalaName,
                    category: category,
                    productWalaNumber: bazaarWalaPhoneNo,
                  ), //
                )
            );
          },
          child: Container(//stack => container(Padding(Column(Row,text,star text, container))) and positioned[for profile pic]
            margin: EdgeInsets.fromLTRB(40,5,20,5),
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(100,20,20,20),//padding is added to move all i.e name,short description, rating and rupee to right to make room for the profile photo
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,//name,short description, ratings and rs all moves down a bit if this is removed
                crossAxisAlignment: CrossAxisAlignment.start,//alignment of ratings and  short description
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.start,//this is removed to decrease space between name and short description
                    children: <Widget>[
                      Container(
                        width:150,//to avoid overflow
                        child: CustomText(text: bazaarWalaName, fontSize: 20,),
                      ),
                      CustomIconButton(
                        iconNameInImageFolder: 'chatBubble',
                        onPressed: (){

                        },
                      ),
                    ],
                  ),
                  //SizedBox(height: 20),
                  //CustomText(text: 'speciality',),
                  //SizedBox(height: 10,),
                  LikesDislikesFetchAndDisplay(productWalaNumber: bazaarWalaPhoneNo, category: category,),
                  SizedBox(height: 5,),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left:20,//left top and bottom for alignment of profile photo wrt to container
          top: 15,
          bottom: 15,
          child: GestureDetector(//for navigation to Product detial page
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetail(
                      productWalaName: bazaarWalaName,
                      category: category,
                      productWalaNumber: bazaarWalaPhoneNo,
                    ), //
                  )
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                width: 110,
                image: AssetImage('images/sampleProfilePicture.jpeg'),
                fit: BoxFit.fill,//to adjust the image with the container
              ),
            ),
          ),
        ),
      ],
    );
  }
}
