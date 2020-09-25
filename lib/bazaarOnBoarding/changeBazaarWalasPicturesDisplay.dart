import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gupshop/bazaarOnBoarding/changeBazaarWalasPicturesAppBar.dart';
import 'package:gupshop/bazaarOnBoarding/pushToFirebase.dart';
import 'package:gupshop/image/fullScreenPictureVideos.dart';
import 'package:gupshop/navigators/navigateToBazaarSubCategorySearch.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';


class ChangeBazaarWalasPicturesDisplay extends StatefulWidget{
  String thumbnailPicture;
  String otherPictureOne;
  String otherPictureTwo;

  final List<String> listOfSubCategoriesForData;
  final List<String> listOfSubCategories;
  final Map<String, String> subCategoryMap;
  final String userName;
  final String userPhoneNo;
  final String category;
  final String categoryData;
  final List<dynamic> deleteListData;
  final List<dynamic> addListData;
  final bool videoChanged;
  final bool locationChanged;
  final String videoURL;
  final LatLng location;
  final double radius;
  final bool isBazaarwala;
  final String aSubCategoryData;

  ChangeBazaarWalasPicturesDisplay({this.thumbnailPicture, this.otherPictureOne,
    this.otherPictureTwo, this.category, this.userName, this.userPhoneNo,
    this.listOfSubCategories, this.subCategoryMap,this.categoryData,
    this.listOfSubCategoriesForData,this.addListData, this.deleteListData,
    this.locationChanged, this.videoChanged,
    this.location, this.videoURL, this.radius,this.isBazaarwala, this.aSubCategoryData
  });

  @override
  _ChangeBazaarWalasPicturesDisplayState createState() => _ChangeBazaarWalasPicturesDisplayState();
}

class _ChangeBazaarWalasPicturesDisplayState extends State<ChangeBazaarWalasPicturesDisplay> with SingleTickerProviderStateMixin{
  TabController imagesController;
  int _activeTabIndex = 0;

  @override
  void initState() {
    imagesController = TabController(length: 3, vsync: this);
    imagesController.addListener(() {_setActiveTabIndex();});
    super.initState();
  }

  @override
  void dispose() {
    imagesController.dispose();
    super.dispose();
  }

  _setActiveTabIndex(){
    setState(() {
      _activeTabIndex =  imagesController.index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
              child: appBar(),
            ),
            body: Center(
              child: Container(
                //height: WidgetConfig.twoFiftyHeight,
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      TabBarView(
                        controller: imagesController,
                        children: <Widget>[
                          /// thumbnailPicture:
                          FullScreenPictureAndVideos(
                            isPicture: true,
                            payLoad: widget.thumbnailPicture,
                            shouldZoom: true,
                          ).noAppBar(context),
                          /// otherPictureOne:
                          FullScreenPictureAndVideos(
                            isPicture: true,
                            payLoad: widget.otherPictureOne,
                            shouldZoom: true,
                          ).noAppBar(context),
                          /// otherPictureTwo:
                          FullScreenPictureAndVideos(
                            isPicture: true,
                            payLoad: widget.otherPictureTwo,
                            shouldZoom: true,
                          ).noAppBar(context),
                        ],
                      ),
                      Container(
                        alignment: FractionalOffset(WidgetConfig.pointFive,WidgetConfig.pointNinetyFive),///placing the tabpagSelector at the bottom  center of the container
                        child: TabPageSelector(
                          controller: imagesController,///if this is not used then the images move but the tabpageSelector does not change the color of the tabs showing which image it is on
                          selectedColor: Colors.grey,///default color is blue
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: CustomFloatingActionButtonWithIcon(
              iconName: 'forward2',
              onPressed: () async{
                ///push all the data here
                PushToFirebase(
                  videoURL: widget.videoURL,
                  location: widget.location,
                  videoChanged: widget.videoChanged,
                  locationChanged: widget.locationChanged,
                  listOfSubCategories: widget.listOfSubCategories,
                  listOfSubCategoriesForData: widget.listOfSubCategoriesForData,
                  radius: widget.radius,
                  addListData: widget.addListData,
                  deleteListData: widget.deleteListData,
                  userPhoneNo: widget.userPhoneNo,
                  categoryData: widget.categoryData,
                  isBazaarwala: widget.isBazaarwala,
                  aSubCategoryData: widget.aSubCategoryData
                ).main();

                NavigateToBazaarSubCategorySearch(
                  categoryData: widget.categoryData,
                  category: widget.category,
                  subCategoriesList: widget.listOfSubCategories,
                  subCategoryMap: widget.subCategoryMap,
                  bazaarWalaName: widget.userName,
                  bazaarWalaPhoneNo: widget.userPhoneNo,
                ).navigateNoBrackets(context);
                //NavigateToViewProfileAsBazaarWalaSubCategories().navigateNoBrackets(context);
              },
            ),
          );
        }
      ),
    );
  }


  appBar() {
     return ChangeBazaarWalasPicturesAppBar(
       tabNumber: _activeTabIndex,
       categoryData: widget.categoryData,
       subCategoryDataList: widget.listOfSubCategoriesForData,

       thumbnailPicture: (newImageURL){
         setState(() {
           widget.thumbnailPicture = newImageURL;
         });
       },

       otherPictureOne: (newImageURL){
         setState(() {
           widget.otherPictureOne = newImageURL;
         });
       },

       otherPictureTwo: (newImageURL){
         setState(() {
           widget.otherPictureTwo = newImageURL;
         });
       },
     );
  }
}
