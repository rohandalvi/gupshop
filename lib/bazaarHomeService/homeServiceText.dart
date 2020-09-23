class HomeServiceText{
  String categoryData;
  String subCategoryData;

  HomeServiceText({this.categoryData, this.subCategoryData});

  /// cleaning
  static String cleaning = "cleaning";
  static String garbageCleaning = "garbageCleaning";
  static String householdCleaning = "householdCleaning";
  static String vehicleCleaning = "vehicleCleaning";

  /// delivery
  static String deliveryErrands = "deliveryErrands";

  /// drivers
  static String drivers = "drivers";


  /// food
  static String food = "food";
  static String caterers = "caterers";
  static String householdCookingService = "householdCookingService";
  static String tiffinService = "tiffinService";
  static String foodHomeDelivery = "Do you deliver at home ? ";
  static String userFoodHomeDelivery = "Do you need home delivery ? ";
  static String uiTextFood = "Home Delivery";
  static String uiTextFoodNo = "No Home Delivery";


  /// grocery
  static String grocery =  "grocery";
  static String dairy =  "dairy";
  static String vegetableVendor =  "vegetableVendor";
  static String fruitVendor = "fruitVendor";
  static String groceryHomeDelivery = "Do you deliver at home ? ";
  static String userGroceryHomeDelivery =  "Do you need home delivery ? ";
  static String uiTextGrocery = "Home Delivery";
  static String uiTextGroceryNo = "No Home Delivery";

  /// parlour
  static String parlour =  "parlour";
  static String hairCut = "hairCut";
  static String massage =  "massage";
  static String salon = "salon";
  static String makeUp = "makeUp";
  static String parlourHomeService = "Do you provide services at home ? ";
  static String userParlourHomeService = "Do you need services at home ? ";
  static String uiTextParlour = "Home Service";
  static String uiTextParlourNo = "No Home Service";


  /// repairs Maintenance
  static String repairsMainTenance = "repairsMainTenance";
  static String appliancesRepairs =  "appliancesRepairs";
  static String carpenters = "carpenters";
  static String electricians = "electricians";
  static String furnitureRepairs =  "furnitureRepairs";
  static String painters =  "painters";
  static String plumbers = "plumbers";
  static String propertyRepairs = "propertyRepairs";
  static String techRepairs = "techRepairs";
  static String vehicleRepairs = "vehicleRepairs";
  static String repairsMainTenanceHomeService = "Do you provide services at home ? ";
  static String userRepairsMainTenanceHomeService = "Do you need services at home ? ";
  static String uiTextRepairsMainTenance = "Home Service";
  static String uiTextRepairsMainTenanceNo = "No Home Service";

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