import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/bazaar/productDetail.dart';
import 'package:gupshop/service/filterBazaarWalas.dart';
import 'package:gupshop/service/geolocation_service.dart';
import 'package:gupshop/service/getSharedPreferences.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customListViewDisplay.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BazaarIndividualCategoryList extends StatefulWidget {
  String category;

  BazaarIndividualCategoryList({@required this.category});

  @override
  _BazaarIndividualCategoryListState createState() => _BazaarIndividualCategoryListState();
}

class _BazaarIndividualCategoryListState extends State<BazaarIndividualCategoryList> {
//  String category = 'KamWali';


  Future<QuerySnapshot> getBazaarWalasInAGivenRadius;

  Position _location;
  double latitude;
  double longitude;


  Future<dynamic> result;
  String userGeohashString;

  Future userPhoneNoFuture;
  String _userPhoneNo;

  List<DocumentSnapshot> list;


  getListOfBazaarWalasInAGivenRadius() async{
    var userPhoneNo = await GetSharedPreferences().getUserPhoneNoFuture();//get user phone no
    _userPhoneNo = userPhoneNo;
    print("widget.category : ${widget.category}");
    var listOfbazaarwalas = await FilterBazaarWalasState().getListOfBazaarWalasInAGivenRadius(userPhoneNo, widget.category);
    return listOfbazaarwalas;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: CustomAppBar(
          title: CustomText(text: widget.category.toUpperCase(), fontSize: 20,),
          onPressed: (){
            Navigator.pop(context);
          }
        ),
      ),
//      appBar: AppBar(
//      actions: <Widget>[
//        IconButton(
//          icon: Icon(Icons.edit_location),
//          onPressed: (){
//            Navigator.push(
//                context,
//                MaterialPageRoute(
//                  //builder: (context) => AddressBook(userPhoneNo:_userPhoneNo),//pass Name() here and pass Home()in name_screen
//                )
//            );
//          },
//          //take user to a new page, to select locations from a given list or add new one
//      ),
//      ],
//      ),
      body: FutureBuilder(
            future: getListOfBazaarWalasInAGivenRadius(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        print("snapshot in futurebuilder: ${snapshot.data}");
        if (snapshot.data == null)
          return CircularProgressIndicator(); //for avoding  the erro

        String bazaarWalaPhoneNo = snapshot.data[0].documentID;
        int numberOfBazaarWalasInList = snapshot.data.length; //for listView builder's itemcount
        print("numberOfBazaarWalasInList : $numberOfBazaarWalasInList");
        String nameOfPeopleInCategory;

        return ListView.builder(
          itemCount: numberOfBazaarWalasInList,
          itemBuilder: (BuildContext context, int index) {
            return StreamBuilder( //use bazaarcategory to display people insted becuase bazaarwalabasicprofile is categorized by phoneNumber now
                stream: Firestore.instance.collection("bazaarCategories")
                    .document(widget.category)
                    .snapshots(),
                builder: (context, streamSnapshot) {
                  if (streamSnapshot.data == null)
                    return CircularProgressIndicator(); //v v imp

                  String name = streamSnapshot.data[bazaarWalaPhoneNo]["name"];
                  int rating = streamSnapshot.data[bazaarWalaPhoneNo]["rating"];
                  bool showRating = !(rating==null);

                  return CustomListViewDisplay(
                    onTapNavigateTo: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetail(
                              productWalaName: name,
                              category: widget.category,
                              productWalaNumber: bazaarWalaPhoneNo,), //
                          )
                      );
                    },
                    display: CustomText(text: name,),
                    showRatings: Visibility(
                        visible: showRating,
                        child: _buildRatingStars(rating)
                    ),
                  );
                }
            );
          },

          );
        }
            return CircularProgressIndicator();
        }
      ),
    );
  }


  Text _buildRatingStars(int rating){
    String stars = '';
    if(rating != null){
      for(int i =0; i<rating; i++){
        stars += '🤩';
      }
    }
    stars.trim();
    return Text(stars);
  }


}
