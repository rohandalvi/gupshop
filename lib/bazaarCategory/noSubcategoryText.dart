import 'package:gupshop/responsive/textConfig.dart';

class NoSubCategoryText{
  String cleaningText = TextConfig.cleaners;
  String deliveryErrandsText = TextConfig.errandsRunners;
  String driversText = TextConfig.drivers;
  String foodText = TextConfig.foodServiceProviders;
  String groceryText = TextConfig.groceryProviders;
  String parlourText = TextConfig.parlourServiceProviders;
  String repairsMaintenanceText = TextConfig.repairsOrMaintenanceServiceProviders;

  String cleaningData = TextConfig.cleaningData;
  String deliveryErrandsData = TextConfig.deliveryErrandsData;
  String driversData = TextConfig.driversData;
  String foodData = TextConfig.foodData;
  String groceryData = TextConfig.groceryData;
  String parlourData = TextConfig.parlourData;
  String repairsMaintenanceData = TextConfig.repairsMaintenanceData;

  getText(String categoryData){
    if(categoryData == cleaningData) return cleaningText;
    if(categoryData == deliveryErrandsData) return deliveryErrandsText;
    if(categoryData == driversData) return driversText;
    if(categoryData == foodData) return foodText;
    if(categoryData == groceryData) return groceryText;
    if(categoryData == parlourData) return parlourText;
    if(categoryData == repairsMaintenanceData) return repairsMaintenanceText;

  }
}