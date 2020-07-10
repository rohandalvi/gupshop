import 'package:flutter/cupertino.dart';
import 'package:gupshop/service/createGroup.dart';

/// required to view bazaarwalas profile page
class SelectCategoryToShowInProductDetailsPage extends StatelessWidget {
  String productWalaName;
  String productWalaNumber;
  List<String> category;

  SelectCategoryToShowInProductDetailsPage({this.productWalaName, this.productWalaNumber, this.category});

  @override
  Widget build(BuildContext context) {
    return CreateGroup(
      userName: productWalaName,
      userPhoneNo: productWalaNumber,
      ///onSearch: category,
    );
  }
}
