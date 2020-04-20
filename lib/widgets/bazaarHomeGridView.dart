import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/screens/bazaarIndividualCategoryList.dart';

class BazaarHomeGridView extends StatefulWidget {
  @override
  _BazaarHomeGridViewState createState() => _BazaarHomeGridViewState();
}

class _BazaarHomeGridViewState extends State<BazaarHomeGridView> {
  List category = ["kamwali", "bhajiwali", "paanwala", "paperwala","Doodhwala", "Appliance Repair", "Parlorwali", "Caterer", "Plumber", "Painter", "TuitionWali", ];
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GridView.count(
        childAspectRatio: 1.5,
        padding: EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: category.map((data){
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[100],
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 14,),//for space between icon and box
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BazaarIndividualCategoryList(),//pass Name() here and pass Home()in name_screen
                        )
                    );
                  },
                  child: Image(
                    //later we will have a string for each image from database and will give that string to AssetImage()
                    image: AssetImage('images/milk.png'),
                    width: 42,
                  ),
                ),
                SizedBox(height: 14,),//this creates a good padding between category name and icon
                Text(
                  data,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),//imp for printing the categories
      ),
    );
  }
}
