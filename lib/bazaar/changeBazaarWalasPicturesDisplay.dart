import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/bazaar/changeBazaarWalasPicturesAppBar.dart';
import 'package:gupshop/bazaar/changeBazaarWalasPicturesBottomBar.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customFloatingActionButton.dart';
import 'package:gupshop/widgets/customText.dart';


class ChangeBazaarWalasPicturesDisplay extends StatefulWidget{
  final String thumbnailPicture;
  final String otherPictureOne;
  final String otherPictureTwo;

  ChangeBazaarWalasPicturesDisplay({this.thumbnailPicture, this.otherPictureOne, this.otherPictureTwo});

  @override
  _ChangeBazaarWalasPicturesDisplayState createState() => _ChangeBazaarWalasPicturesDisplayState();
}

class _ChangeBazaarWalasPicturesDisplayState extends State<ChangeBazaarWalasPicturesDisplay> with SingleTickerProviderStateMixin{
  TabController imagesController;
  int _activeTabIndex;

  @override
  void initState() {
    print("in initstate");
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
    print("_activeTabIndex : $_activeTabIndex");
  }


  @override
  Widget build(BuildContext context) {
    print(" this index : ${imagesController.index}");

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: ChangeBazaarWalasPicturesAppBar(tabNumber: _activeTabIndex,),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 250.0,
            child: Center(
              child: Stack(
                children: <Widget>[
                  TabBarView(
                    controller: imagesController,
                    children: <Widget>[
                      /// thumbnailPicture:
                      Image(
                        image: NetworkImage(widget.thumbnailPicture),
                      ),
                      /// otherPictureOne:
                      Image(
                        image: NetworkImage(widget.otherPictureOne),
                      ),
                      /// otherPictureTwo:
                      Image(
                        image: NetworkImage(widget.otherPictureTwo),
                      ),
                    ],
                  ),
                  Container(
                    alignment: FractionalOffset(0.5,0.95),///placing the tabpagSelector at the bottom  center of the container
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
      ),
    );
  }
}
