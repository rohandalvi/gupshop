import 'package:gupshop/responsive/textConfig.dart';

class HomeServiceText{
  String categoryData;
  String subCategoryData;

  HomeServiceText({this.categoryData, this.subCategoryData});

  /// cleaning
  static String cleaning = TextConfig.cleaningData;//"cleaning";
  static String garbageCleaning = TextConfig.garbageCleaningData;//"garbageCleaning";
  static String householdCleaning = TextConfig.householdCleaningData;//"householdCleaning";
  static String vehicleCleaning = TextConfig.vehicleCleaningData; //"vehicleCleaning";

  /// delivery
  static String deliveryErrands = TextConfig.deliveryErrandsData;//"deliveryErrands";

  /// drivers
  static String drivers = TextConfig.driversData;//"drivers";


  /// food
  static String food = TextConfig.foodData;//"food";
  static String caterers = TextConfig.caterersData;//"caterers";
  static String householdCookingService = TextConfig.householdCookingService;
  static String tiffinService = TextConfig.tiffinService;
  static String foodHomeDelivery = TextConfig.foodGroceryHomeDelivery;
  static String userFoodHomeDelivery = TextConfig.userFoodGroceryHomeDelivery;
  static String uiTextFood = TextConfig.uiTextHomeDelivery;
  static String uiTextFoodNo = TextConfig.uiTextNoHomeDelivery;


  /// grocery
  static String grocery =  TextConfig.groceryData;//"grocery";
  static String dairy = TextConfig.dairyData;
  static String vegetableVendor =  TextConfig.vegetableVendorData;
  static String fruitVendor = TextConfig.fruitVendorData;
  static String groceryHomeDelivery = TextConfig.foodGroceryHomeDelivery;
  static String userGroceryHomeDelivery =  TextConfig.userFoodGroceryHomeDelivery;
  static String uiTextGrocery = TextConfig.uiTextHomeDelivery;
  static String uiTextGroceryNo = TextConfig.uiTextNoHomeDelivery;

  /// parlour
  static String parlour =  TextConfig.parlourData;
  static String hairCut = TextConfig.hairCutData;
  static String massage =  TextConfig.massageData;
  static String salon = TextConfig.salonData;
  static String makeUp = TextConfig.makeUpData;
  static String parlourHomeService = TextConfig.parlourRepairsMaintHomeService;
  static String userParlourHomeService = TextConfig.userParlourHomeService;
  static String uiTextParlour = TextConfig.uiTextHomeService;
  static String uiTextParlourNo = TextConfig.uiTextNoHomeService;


  /// repairs Maintenance
  static String repairsMainTenance = TextConfig.repairsMaintenanceData;//"repairsMainTenance";
  static String appliancesRepairs =  TextConfig.appliancesRepairsData;
  static String carpenters = TextConfig.carpentersData;
  static String electricians = TextConfig.electriciansData;
  static String furnitureRepairs =  TextConfig.furnitureRepairsData;
  static String painters =  TextConfig.paintersData;
  static String plumbers = TextConfig.plumbersData;
  static String propertyRepairs = TextConfig.propertyRepairsData;
  static String techRepairs = TextConfig.techRepairsData;
  static String vehicleRepairs = TextConfig.vehicleRepairsData;
  static String repairsMainTenanceHomeService = TextConfig.parlourRepairsMaintHomeService;
  static String userRepairsMainTenanceHomeService = TextConfig.userParlourHomeService;
  static String uiTextRepairsMainTenance = TextConfig.uiTextHomeService;
  static String uiTextRepairsMainTenanceNo = TextConfig.uiTextNoHomeService;

  uiDisplayText(){
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