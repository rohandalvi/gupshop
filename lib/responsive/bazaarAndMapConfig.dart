import 'package:gupshop/bazaarHomeService/homeServiceText.dart';

class BazaarConfig{
  String categoryData;
  String subCategoryData;
  String category;
  String subCategory;

  BazaarConfig({this.category, this.subCategoryData, this.subCategory, this.categoryData});

  static const String loadingMap = "Loading map";
  static const String mapDriverSearchPlaceholder = "your destination";

  /// for maps:
  getPickLocation(){
    String placeHolder;
    if(categoryData == HomeServiceText.drivers) {
      placeHolder = mapDriverSearchPlaceholder;
    }
    else placeHolder = category;/// for delivery errands
    return "Pick $placeHolder location";
  }

}