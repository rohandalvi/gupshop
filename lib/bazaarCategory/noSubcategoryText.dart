class NoSubCategoryText{
  String cleaningText = "Cleaners";
  String deliveryErrandsText = "Errand runners";
  String driversText = "Drivers";
  String foodText = "Food Service providers";
  String groceryText = "Grocery providers";
  String parlourText = "Parlour Service providers";
  String repairsMaintenanceText = "Repairs or Maintenance Service providers";

  String cleaningData = "cleaning";
  String deliveryErrandsData = "deliveryErrands";
  String driversData = "drivers";
  String foodData = "food";
  String groceryData = "grocery";
  String parlourData = "parlour";
  String repairsMaintenanceData = "repairsMaintenance";

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