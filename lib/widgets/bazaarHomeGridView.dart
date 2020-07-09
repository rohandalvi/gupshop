import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/screens/bazaarIndividualCategoryList.dart';
import 'package:gupshop/widgets/customText.dart';

class BazaarHomeGridView extends StatefulWidget {
  @override
  _BazaarHomeGridViewState createState() => _BazaarHomeGridViewState();
}

class _BazaarHomeGridViewState extends State<BazaarHomeGridView> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("bazaarCategoryTypesAndImages").snapshots(),
      builder: (context, snapshot) {
        if(snapshot.data == null) return CircularProgressIndicator();//for avoding  the error

        int categoryLength = snapshot.data.documents.length;//for using in
        return Flexible(
          child: Padding(
            padding: EdgeInsets.all(15.0),//for space between boxes and left and right screen
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  crossAxisSpacing: 18,///spaces between the boxes verically
                  mainAxisSpacing: 10,///spaces between the boxes horizaontally
                  childAspectRatio: 0.85,///size of the box 1.3
                ),
                itemCount: categoryLength,
                itemBuilder: (BuildContext context, int index){
                  String catergoryName = snapshot.data.documents[index].data['name'];
                  String categoryNameForBazaarIndividualCategoryList = snapshot.data.documents[index].documentID;
                  print("categoryNameForBazaarIndividualCategoryList : $categoryNameForBazaarIndividualCategoryList");
                  String image = snapshot.data.documents[index].data['icon'];

                  return Container(
                    padding: EdgeInsets.all(16),
                    //padding: EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 14,),//for space between icon and box on top
                        InkWell(
                          onTap: (){
                            print("categoryNameForBazaarIndividualCategoryList in onTap: $categoryNameForBazaarIndividualCategoryList");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BazaarIndividualCategoryList(category: categoryNameForBazaarIndividualCategoryList,),//pass Name() here and pass Home()in name_screen
                                )
                            );
                          },
                          child:  IconButton(
                            icon: SvgPicture.network(image),
                            iconSize: 70,
                          )
                        ),
                        SizedBox(height: 14,),//this creates a good padding between category name and icon
                        CustomText(text: catergoryName,),
                      ],
                    ),
                  );
                },
            ),
          ),
        );
      }
    );
  }
}


//child: GridView.count(
//childAspectRatio: 1.5,
//padding: EdgeInsets.only(left: 16, right: 16),
//crossAxisCount: 2,
//crossAxisSpacing: 18,
//mainAxisSpacing: 18,
//children: category.map((data){
//return Container(
//decoration: BoxDecoration(
//borderRadius: BorderRadius.circular(10),
//color: Colors.grey[100],
//),
//child: Column(
//children: <Widget>[
//SizedBox(height: 14,),//for space between icon and box
//InkWell(
//onTap: (){
//Navigator.push(
//context,
//MaterialPageRoute(
//builder: (context) => BazaarIndividualCategoryList(),//pass Name() here and pass Home()in name_screen
//)
//);
//},
//child: Image(
////later we will have a string for each image from database and will give that string to AssetImage()
//image: AssetImage('images/milk.png'),
//width: 42,
//),
//),
//SizedBox(height: 14,),//this creates a good padding between category name and icon
//Text(
//data,
//style: GoogleFonts.openSans(
//textStyle: TextStyle(
//fontWeight: FontWeight.w600,
//fontSize: 16,
//),
//),
//),
//],
//),
//);
//}).toList(),//imp for printing the categories
//),