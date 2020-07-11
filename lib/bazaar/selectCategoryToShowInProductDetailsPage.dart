import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/getCategoriesSubscribedTo.dart';
import 'package:gupshop/service/contact_search.dart';
import 'package:gupshop/service/customNavigators.dart';
import 'package:gupshop/widgets/customSearch.dart';
import 'package:gupshop/widgets/customText.dart';

/// required to view bazaarwalas profile page
class SelectCategoryToShowInProductDetailsPage extends StatefulWidget {
  String productWalaName;
  String productWalaNumber;

  SelectCategoryToShowInProductDetailsPage({this.productWalaName, this.productWalaNumber});

  @override
  _SelectCategoryToShowInProductDetailsPageState createState() => _SelectCategoryToShowInProductDetailsPageState();
}

class _SelectCategoryToShowInProductDetailsPageState extends State<SelectCategoryToShowInProductDetailsPage> {

  List<String> categoryList;

  getCategoryList() async{
    List<String> list = await GetCategoriesSubscribedTo(userNumber: widget.productWalaNumber, userName: widget.productWalaName).getCategoriesAsSuggestionList();
    setState(() {
      categoryList = list;
    });
    print("categoryList : $categoryList");
  }

  @override
  void initState() {
    print("in _SelectCategoryToShowInProductDetailsPageState");
    getCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSearch<String>(
      hintText: 'View your Bazaar Profile as: ',
      onSearch: searchCategoryList,
      suggestions: categoryList == null ? new List() : categoryList,
      onItemFound: (String category, int index){
        return ListTile(
          title: CustomText(text: category),
          ///displaying on the display name
          onTap:NavigateToProductDetailsPage(productWalaNumber:widget.productWalaNumber, productWalaName:widget.productWalaName, category: category).navigate(context),
        );
      },
    );
  }// List<String> listOfCategoriesSelected = snapshot.data["categories"].cast<String>()


  Future<List<String>> searchCategoryList(String text) async {
    List<String> list = await GetCategoriesSubscribedTo(userNumber:widget.productWalaNumber, userName:widget.productWalaName).getCategories(text);
    print("list in searchCategoryList :$list");
    return list.where((l) => l.toLowerCase()
        .contains(text.toLowerCase()) || l.contains(text)).toList();
  }
}
