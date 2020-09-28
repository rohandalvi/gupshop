import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/navigators/navigateToProductDetailPage.dart';
import 'package:gupshop/retriveFromFirebase/getCategoriesFromCategoriesMetadata.dart';
import 'package:gupshop/widgets/customText.dart';

class ViewProfileAsBazaarWalaData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCategoriesFromCategoriesMetadata().selectedCategories(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print("snapshot.data in  viewProfile : ${snapshot.data}");

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
    );
  }
}
