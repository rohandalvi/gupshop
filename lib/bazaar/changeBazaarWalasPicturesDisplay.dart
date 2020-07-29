import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customBottomSheet.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

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
        child: CustomAppBar(
          title: CustomText(text: 'Change Pictures', fontSize: 20,),
          actions: <Widget>[
            /// CustomIconButton needs to be wrapped in a builder to pass
            /// the context to CustomBottomSheet else it gives the error:
            /// no scaffold found
            Builder(
              builder: (context) {
                return CustomIconButton(
                  iconNameInImageFolder: 'editPencil',
                  onPressed: (){
                    CustomBottomSheet(
                      customContext: context,
                      firstIconName: 'photoGallery',
                      firstIconText: 'Pick image from  Gallery',
                      firstIconAndTextOnPressed: (){},
                      secondIconName: 'image2vector',
                      secondIconText: 'Click image from Camera',
                      secondIconAndTextOnPressed: (){},
                    ).showTwo();
                  },
                );
              }
            ),
          ],
          onPressed:(){
            Navigator.pop(context);
          },),
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
