import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarWalasBasicProfileCollection.dart';
import 'package:gupshop/bazaarHomeService/homeServiceText.dart';
import 'package:gupshop/colors/colorPalette.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToBazaarOnBoardingHome.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/contactSearch/contact_search.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';
import 'package:gupshop/retriveFromFirebase/getCategoriesFromCategoriesMetadata.dart';
import 'package:gupshop/widgets/customDialogForConfirmation.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customText.dart';

class SubCategoriesCheckBox extends StatefulWidget {
  final String category;
  final String categoryData;
  final Future<List<DocumentSnapshot>> subCategoriesListFuture;
  final List<DocumentSnapshot> subCategoriesList;
  Map<String, String> subCategoryMap;
  final bool isBazaarwala;

  Map<String, bool > map;


  SubCategoriesCheckBox({this.subCategoriesList, this.subCategoriesListFuture,
    this.category, this.subCategoryMap, this.categoryData, this.map, this.isBazaarwala});

  @override
  _SubCategoriesCheckBoxState createState() => _SubCategoriesCheckBoxState();
}

class _SubCategoriesCheckBoxState extends State<SubCategoriesCheckBox> {
  List<String> listOfSubCategories = new List();
  Set tempSet = new HashSet();
  List<String> listOfSubCategoriesForData = new List();
  bool isCategorySelected = false;

  Map initialMap;

  Map<String, bool> homeServiceMap = new HashMap();


  getCategorySizeFuture() {
    Map mapOfDocumentSnapshots = widget.subCategoriesList.asMap();
    /// initializing 'map' with false values
    mapOfDocumentSnapshots.forEach((key, value) {
      String temp = mapOfDocumentSnapshots[key].data[TextConfig.name];
      widget.map.putIfAbsent(temp, () => false);
    });
  }


  /// if the user is already a bazaarwala then the categories should already
  /// be selected and the forward button should also be visible.
  /// To check if the user has selected any categories, then isCategorySelected
  /// would show as true and would make the forward icon visible.
  categorySelectedCheck() async{
    List<DocumentSnapshot> dc = await GetCategoriesFromCategoriesMetadata
      (category: widget.categoryData,).selectedCategories();

    /// if the user is never registered as a bazaarwala ever then dc would be
    /// empty, hence the check
    if(dc.isEmpty == true || dc[0].data.isEmpty == true){
      setState(() {
        isCategorySelected = false;
      });
    }else{
      setState(() {
        isCategorySelected = true;
      });
    }
  }


  selectedCategoryListFromDatabase(){
    widget.map.forEach((key, value) { });
  }

  @override
  void initState() {
    getCategorySizeFuture();
    categorySelectedCheck();

    initialMap = Map.of(widget.map);

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: <Widget>[
          appBarBody(context),
          showButton(), /// would show only if one or more contact is selected
        ],
      ),
    );
  }


  Widget appBarBody(BuildContext context) {
      return ContactSearch(
        suggestions: widget.subCategoriesList,
        navigate: NavigateToBazaarOnBoardingHome().navigate(context),
        onSearch: searchList,
        hintText: TextConfig.speciality,
        onItemFound: (DocumentSnapshot doc, int index) {
            return Container(
            child: CheckboxListTile(
                controlAffinity:ListTileControlAffinity.leading ,
                title:CustomText(text: doc.data[TextConfig.name]),
                activeColor: primaryColor,
                value: widget.map[doc.data[TextConfig.name]],/// if value of a key in map(a subcategory name) is false or true
                //list[index],/// at first all the values would be false
                onChanged: (bool val) async{
                  setState((){
                    widget.map[doc.data[TextConfig.name]] = val; /// setting the new value as selected by user
                    isCategorySelected = isSubCategorySelectedWidget();
                  });


                  String subCategoryData = widget.subCategoryMap[doc.data[TextConfig.name]];


                  /// homeService dialog box:
                  String isHomeServiceApplicable = HomeServiceText(categoryData:widget.categoryData,
                      subCategoryData: subCategoryData).bazaarWalasdialogText();
                  if(isHomeServiceApplicable != null){
                    bool homeService = false;

                    if(val == true){
                      homeService = await homeServiceDialog(isHomeServiceApplicable);
                    }

                    ///make a map of subCategories to homeService:
                    homeServiceMap[subCategoryData] = homeService;
                    print("homeServiceMap : $homeServiceMap");

                    //pushToBazaarWalasBasicProfile(subCategoryData, homeService);
                  }
                }
            ),
          );
        },
        //onItemFound: ,
      );
  }

  mergeMaps(Map categorySelectedMap, Map blankMap){

    blankMap.forEach((key, value) {
      if(categorySelectedMap.containsKey(key)){
        blankMap[key] = true;
      }
    });
  }

  homeServiceDialog(String homeServiceText) async{
      bool temp = await CustomDialogForConfirmation(
        /// from homeServiceText
          title: homeServiceText,
          content: "",
          barrierDismissible: false,
      ).dialog(context);
      return temp;
  }


  /// push this at the end
  pushToBazaarWalasBasicProfile(String subCategoryData, bool homeService) async{
    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();
      await PushToBazaarWalasBasicProfile(
        categoryData: widget.categoryData,
        subCategoryData: subCategoryData,
        userPhoneNo: userPhoneNo,
        homeService: homeService,
      ).pushHomeService();
  }


  Future<List<DocumentSnapshot>> searchList(String text) async {
    List<DocumentSnapshot> list = await widget.subCategoriesListFuture;
    return list.where((l) =>
    l.data[TextConfig.name]
        .toLowerCase()
        .contains(text.toLowerCase()) || l.documentID.contains(text)).toList();
  }


  bool isSubCategorySelectedWidget(){
    return widget.map.containsValue(true);
  }

  isSubCategoryBazaarwalaWidget() async{
    String userNumber = await UserDetails().getUserPhoneNoFuture();

    bool isSubCategoryBazaarwala = await GetBazaarWalasBasicProfileInfo(
      userNumber: userNumber,
      categoryData: widget.categoryData,
      subCategoryData: listOfSubCategoriesForData[0],
    ).getIsBazaarwala();
    return isSubCategoryBazaarwala;
  }

  showButton() {
    return Visibility(
      visible: isCategorySelected,
      child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: WidgetConfig.groupIconHeight,/// to increase the size of floatingActionButton use container along with FittedBox
            width: WidgetConfig.groupIconWidth,
            child: FittedBox(
              child: CustomFloatingActionButtonWithIcon(
                  iconName: IconConfig.forward,
                  tooltip: 'Go ahead',
                  /// create a listOfContactsSelected and send it to individualChat
                  onPressed: () async{
                    String userName = await UserDetails().getUserNameFuture();
                    String userNumber = await UserDetails().getUserPhoneNoFuture();

                    /// create subCategories list:
                    subCategoriesList();

                    /// if already a bazaarwala then, delete and update
                    /// and not push
                    //bool tempIsSubCategoryBazaarwala = await isSubCategoryBazaarwalaWidget();
                    List deleteListData;
                    List addListData;

                    if(widget.isBazaarwala == true){
                      List<Map> list = newSubCategories(initialMap, widget.map);
                      Map deleteMap = list[0];
                      Map addMap = list[1];

                      /// if already a bazaarwala and a category is deleted
                      if(deleteMap.isNotEmpty){
                        deleteListData = listFromMapValues(deleteMap);
                      }

                      /// if already a bazaarwala and a category is added
                      if(addMap.isNotEmpty){
                        addListData = listFromMapValues(addMap);
                      }
                    }

                    /// moving on to next page:
                    Map<String,dynamic> navigatorMap = new Map();
                    navigatorMap[TextConfig.category] = widget.category;
                    navigatorMap[TextConfig.categoryData] = widget.categoryData;
                    navigatorMap[TextConfig.listOfSubCategories] = listOfSubCategories;
                    navigatorMap[TextConfig.userPhoneNo] = userNumber;
                    navigatorMap[TextConfig.userName] = userName;
                    navigatorMap[TextConfig.subCategoryMap] = widget.subCategoryMap;
                    navigatorMap[TextConfig.listOfSubCategoriesForData] = listOfSubCategoriesForData;
                    navigatorMap[TextConfig.homeServiceMap] = homeServiceMap;

                    Navigator.pushNamed(context, NavigatorConfig.bazaarAdvertisement, arguments: navigatorMap);
                  }
              ),
            ),
          )
      ),
    );
  }

  subCategoriesList() {
    bool isAdded;

    widget.map.forEach((key, value) {
      if(value == true){
        isAdded = tempSet.add(key);/// adding the numbers in a set because, if the user comes back from the nameScreen then the numbers shouldnt duplicate in the list, using set ensures that.
        if(isAdded == true){/// if the set already has the number added then dont add it again in the list
          listOfSubCategories.add(key);
          listOfSubCategoriesForData.add(widget.subCategoryMap[key]);
        }
      }
    });
  }


  /// initial map : initialMap,
  /// newMap : widget.map
  newSubCategories(Map initialMap, Map newMap ){
    List<Map> list = new List();

    Map deleteMap = new HashMap();
    Map addMap = new HashMap();

    initialMap.forEach((key, value) {
      if(initialMap[key] == true && newMap[key] == false){
        String subCategoryData = widget.subCategoryMap[key];
        deleteMap[key] = subCategoryData;
      }
      if(initialMap[key] == false && newMap[key] == true){
        String subCategoryData = widget.subCategoryMap[key];
        addMap[key] = subCategoryData;
      }
    });

    list.add(deleteMap);
    list.add(addMap);

    return list;
  }


  listFromMapValues(Map map){
    List result = new List();

    map.forEach((key, value) {
      result.add(map[key]);
    });

    return result;
  }
}
