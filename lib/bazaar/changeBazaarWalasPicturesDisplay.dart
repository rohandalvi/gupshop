import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/changeBazaarWalasPicturesAppBar.dart';


class ChangeBazaarWalasPicturesDisplay extends StatefulWidget{
  final String thumbnailPicture;
  final String otherPictureOne;
  final String otherPictureTwo;

  ChangeBazaarWalasPicturesDisplay({this.thumbnailPicture, this.otherPictureOne, this.otherPictureTwo});

  @override
  _ChangeBazaarWalasPicturesDisplayState createState() => _ChangeBazaarWalasPicturesDisplayState();
}

class _ChangeBazaarWalasPicturesDisplayState extends State<ChangeBazaarWalasPicturesDisplay> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    TabController imagesController = new TabController(length: 3, vsync: this);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: ChangeBazaarWalasPicturesAppBar()
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 250.0,
            child: Center(
              child: DefaultTabController(
                length: 3,
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
      ),

    );
  }
}
