import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/retriveFromFirebase/getCategoriesFromCategoriesMetadata.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/navigators/navigateToProductDetailPage.dart';

class ViewProfileAsBazaarWala extends StatefulWidget {
  @override
  _ViewProfileAsBazaarWalaState createState() => _ViewProfileAsBazaarWalaState();
}

class _ViewProfileAsBazaarWalaState extends State<ViewProfileAsBazaarWala> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: CustomAppBar(),
      ),
      body: FutureBuilder(
        future: GetCategoriesFromCategoriesMetadata().main(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {

            int categoriesLength = snapshot.data["categories"].length;

            return ListView.separated(
              itemCount: categoriesLength,
              itemBuilder: (context, index){
                String categoryName = snapshot.data["categories"][index];

                return ListTile(
                  title: GestureDetector(
                      child: CustomText(text: categoryName,),
                    onTap: (){
                      NavigateToProductDetailPage(category: categoryName).navigateNoBrackets(context);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) =>
                  Divider( //to divide the chat list
                    color: Colors.white,
                  ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      )
    );
  }
}
