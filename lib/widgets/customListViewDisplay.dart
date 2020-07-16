import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/productDetail.dart';
import 'package:gupshop/widgets/customText.dart';

class CustomListViewDisplay extends StatelessWidget {
  GestureTapCallback onTapNavigateTo;
  Widget display;
  Widget showRatings;

  CustomListViewDisplay({this.onTapNavigateTo, this.display, this.showRatings});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(//for navigation to Product detial page
          onTap: onTapNavigateTo,
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
                        child: display,
                      ),
                      IconButton(
                        icon: Icon(Icons.chat_bubble_outline),
                      ),
                    ],
                  ),
                  //SizedBox(height: 20),
                  //CustomText(text: 'speciality',),
                  //SizedBox(height: 10,),
                  showRatings,
                  SizedBox(height: 5,),
                  Container(
                    child: Text('Rs'),
                    alignment: Alignment.center,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
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
            onTap: onTapNavigateTo,
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