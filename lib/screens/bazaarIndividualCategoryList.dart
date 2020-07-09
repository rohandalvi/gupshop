import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/screens/productDetail.dart';
import 'package:gupshop/service/filterBazaarWalas.dart';
import 'package:gupshop/service/geolocation_service.dart';
import 'package:gupshop/service/getSharedPreferences.dart';
import 'package:gupshop/widgets/customListViewDisplay.dart';
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
    var listOfbazaarwalas = await FilterBazaarWalasState().getListOfBazaarWalasInAGivenRadius(userPhoneNo, widget.category);
    return listOfbazaarwalas;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.edit_location),
          onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                  //builder: (context) => AddressBook(userPhoneNo:_userPhoneNo),//pass Name() here and pass Home()in name_screen
                )
            );
          },
          //take user to a new page, to select locations from a given list or add new one
      ),
      ],
      ),
      body: FutureBuilder(
          future: getListOfBazaarWalasInAGivenRadius(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print("snapshot in futurebuilder: $snapshot");

          if(snapshot.data == null) return CircularProgressIndicator();//for avoding  the erro

          String bazaarWalaPhoneNo = snapshot.data[0].documentID;
          int numberOfBazaarWalasInList = snapshot.data.length;//for listView builder's itemcount
          String nameOfPeopleInCategory;

          return ListView.builder(
            itemCount: numberOfBazaarWalasInList,
            itemBuilder: (BuildContext context, int index){


              return StreamBuilder(//use bazaarcategory to display people insted becuase bazaarwalabasicprofile is categorized by phoneNumber now
                  stream: Firestore.instance.collection("bazaarCategories").document(widget.category).snapshots(),
                  builder: (context, streamSnapshot){

                    if(streamSnapshot.data == null) return CircularProgressIndicator();//v v imp

                    String name = streamSnapshot.data[bazaarWalaPhoneNo]["name"];
                    print("name in bazaarIndividualCategory: $name");
                    int rating = streamSnapshot.data[bazaarWalaPhoneNo]["rating"];

                  return CustomListViewDisplay(
                    onTapNavigateTo: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetail(productWalaName: name, category:widget.category, productWalaNumber: bazaarWalaPhoneNo,),//
                          )
                      );
                    },
                    display: CustomText(text: name,),
                    showRatings: _buildRatingStars(rating),
                  );
//              return Stack(
//                children: <Widget>[
//                  GestureDetector(//for navigation to Product detial page
//                    onTap: (){
//                      Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                            builder: (context) => ProductDetail(productWalaName: name, category:widget.category),//
//                          )
//                      );
//                    },
//                    child: Container(//stack => container(Padding(Column(Row,text,star text, container))) and positioned[for profile pic]
//                      margin: EdgeInsets.fromLTRB(40,5,20,5),
//                      height: 150,
//                      width: double.infinity,
//                      decoration: BoxDecoration(
//                        color: Colors.white,
//                        borderRadius: BorderRadius.circular(20),
//                      ),
//                      child: Padding(
//                        padding: EdgeInsets.fromLTRB(100,20,20,20),//padding is added to move all i.e name,short description, rating and rupee to right to make room for the profile photo
//                        child: Column(
//                          mainAxisAlignment: MainAxisAlignment.center,//name,short description, ratings and rs all moves down a bit if this is removed
//                          crossAxisAlignment: CrossAxisAlignment.start,//alignment of ratings and  short description
//                          children: <Widget>[
//                            Row(
//                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                              //crossAxisAlignment: CrossAxisAlignment.start,//this is removed to decrease space between name and short description
//                              children: <Widget>[
//                                Container(
//                                  width:150,//to avoid overflow
//                                  child: Text(
//                                    name,
//                                    style: GoogleFonts.openSans(
//                                      fontSize: 18,
//                                      fontWeight: FontWeight.w600,
//                                    ),
//                                    maxLines: 2,//to avoid overflow
//                                    overflow: TextOverflow.ellipsis,//to avoid overflow, show dots
//                                  ),
//                                ),
//                                IconButton(
//                                  icon: Icon(Icons.chat_bubble_outline),
//                                ),
//                              ],
//                            ),
//                            //SizedBox(height: 20),
//                            Text(
//                              'speciality',
//                              style: GoogleFonts.openSans(
//                                fontSize: 9,
//                                fontWeight: FontWeight.w600,
//                                color: Colors.blueGrey,
//                              ),
//                            ),
//                            SizedBox(height: 10,),
//                            _buildRatingStars(rating),
//                            SizedBox(height: 5,),
//                            Container(
//                                child: Text('Rs'),
//                              alignment: Alignment.center,
//                              width: 50,
//                              decoration: BoxDecoration(
//                                color: Theme.of(context).accentColor,
//                                borderRadius: BorderRadius.circular(10),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                  Positioned(
//                    left:20,//left top and bottom for alignment of profile photo wrt to container
//                    top: 15,
//                    bottom: 15,
//                    child: GestureDetector(//for navigation to Product detial page
//                      onTap: (){
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => ProductDetail(productWalaName: name, category:widget.category),
//                            )
//                        );
//                      },
//                      child: ClipRRect(
//                        borderRadius: BorderRadius.circular(20),
//                        child: Image(
//                          width: 110,
//                          image: AssetImage('images/sampleProfilePicture.jpeg'),
//                          fit: BoxFit.fill,//to adjust the image with the container
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              );
              }
              );
            },

          );
        }
      ),
    );
  }


  Text _buildRatingStars(int rating){
    String stars = '';
    for(int i =0; i<rating; i++){
      stars += '🤩';
    }
    stars.trim();
    return Text(stars);
  }


}
