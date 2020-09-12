class HomeServiceText{
  String categoryData;
  String subCategoryData;

  HomeServiceText({this.categoryData, this.subCategoryData});

  /// cleaning
  String cleaning = "cleaning";
  String garbageCleaning = "garbageCleaning";
  String householdCleaning = "householdCleaning";
  String vehicleCleaning = "vehicleCleaning";

  /// delivery
  String deliveryErrands = "deliveryErrands";


  /// food
  String food = "food";
  String caterers = "caterers";
  String householdCookingService = "householdCookingService";
  String tiffinService = "tiffinService";
  String foodHomeDelivery = "Do you deliver at home ? ";
  String userFoodHomeDelivery = "Do you need home delivery ? ";
  String uiTextFood = "Home Delivery";
  String uiTextFoodNo = "No Home Delivery";


  /// grocery
  String grocery =  "grocery";
  String dairy =  "dairy";
  String vegetableVendor =  "vegetableVendor";
  String fruitVendor = "fruitVendor";
  String groceryHomeDelivery = "Do you deliver at home ? ";
  String userGroceryHomeDelivery =  "Do you need home delivery ? ";
  String uiTextGrocery = "Home Delivery";
  String uiTextGroceryNo = "No Home Delivery";

  /// parlour
  String parlour =  "parlour";
  String hairCut = "hairCut";
  String massage =  "massage";
  String salon = "salon";
  String makeUp = "makeUp";
  String parlourHomeService = "Do you provide services at home ? ";
  String userParlourHomeService = "Do you need services at home ? ";
  String uiTextParlour = "Home Service";
  String uiTextParlourNo = "No Home Service";


  /// repairs Maintenance
  String repairsMainTenance = "repairsMainTenance";
  String appliancesRepairs =  "appliancesRepairs";
  String carpenters = "carpenters";
  String electricians = "electricians";
  String furnitureRepairs =  "furnitureRepairs";
  String painters =  "painters";
  String plumbers = "plumbers";
  String propertyRepairs = "propertyRepairs";
  String techRepairs = "techRepairs";
  String vehicleRepairs = "vehicleRepairs";
  String repairsMainTenanceHomeService = "Do you provide services at home ? ";
  String userRepairsMainTenanceHomeService = "Do you need services at home ? ";
  String uiTextRepairsMainTenance = "Home Service";
  String uiTextRepairsMainTenanceNo = "No Home Service";

  uiDisplayText(){
    print("categoryData in uiDisplayText : $categoryData");
    if(categoryData == food) return uiTextFood;
    if(categoryData == grocery) return uiTextGrocery;
    if(categoryData == parlour) return uiTextParlour;
    if(categoryData == repairsMainTenance) return uiTextRepairsMainTenance;
  }

  uiDisplayTextNo(){
    if(categoryData == food) return uiTextFoodNo;
    if(categoryData == grocery) return uiTextGroceryNo;
    if(categoryData == parlour) return uiTextParlourNo;
    if(categoryData == repairsMainTenance) return uiTextRepairsMainTenanceNo;
  }


  userDialogDisplayText(){
    String result = bazaarWalasdialogText();
    if(result == foodHomeDelivery) return userFoodHomeDelivery;
    else if(result == groceryHomeDelivery) return userGroceryHomeDelivery;
    else if(result == parlourHomeService) return userParlourHomeService;
    else if(result == repairsMainTenanceHomeService) return userRepairsMainTenanceHomeService;
    else return null;
  }


  /// appears on onBoarding
  bazaarWalasdialogText(){
    /// cleaning, deliveryErrands
    if(categoryData == cleaning
        || categoryData == deliveryErrands
    ) return null;

    /// food
    if(categoryData == food){
      if(subCategoryData == householdCookingService) return null;

      if(subCategoryData == caterers || subCategoryData == tiffinService)
        return foodHomeDelivery;
    }

    /// grocery
    if(categoryData == grocery) return groceryHomeDelivery;

    /// parlour
    if(categoryData == parlour) return parlourHomeService;

    /// repairs Maintenance
    if(categoryData == repairsMainTenance){
      if(subCategoryData == appliancesRepairs
          || subCategoryData == techRepairs || subCategoryData == vehicleRepairs) {
        return repairsMainTenanceHomeService;
      }return null;
    }
  }


}