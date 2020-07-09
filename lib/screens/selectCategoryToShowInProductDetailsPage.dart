import 'package:flutter/cupertino.dart';
import 'package:gupshop/service/createGroup.dart';

class SelectCategoryToShowInProductDetailsPage extends StatelessWidget {
  String productWalaName;
  String productWalaNumber;
  List<String> category;

  SelectCategoryToShowInProductDetailsPage({this.productWalaName, this.productWalaNumber, this.category});

  @override
  Widget build(BuildContext context) {
    return CreateGroup();
  }
}
