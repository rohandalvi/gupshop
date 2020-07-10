import 'dart:collection';

class CreateMapFromListOfCategories{
  createMap(List<String> listOfCategoriesSelected, Map<String, bool> mapOfAllCategoriesWithFalseValues){
    for(int i= 0; i<listOfCategoriesSelected.length; i++){
      String categoryName = listOfCategoriesSelected[i];
      mapOfAllCategoriesWithFalseValues.update(categoryName, (value) => true);
    }
    return mapOfAllCategoriesWithFalseValues;
  }
}