class BazaarConfig{
  String categoryData;
  String subCategoryData;
  String category;
  String subCategory;

  BazaarConfig({this.category, this.subCategoryData, this.subCategory, this.categoryData});

  /// for maps:
  getPickLocation(){
    return "Pick $category location";
  }

  static const String loadingMap = "Loading map";

}