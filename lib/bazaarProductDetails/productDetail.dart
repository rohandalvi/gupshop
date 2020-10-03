import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaarProductDetails/chatWithBazaarwala.dart';
import 'package:gupshop/bazaarProductDetails/productDetailsAppBar.dart';
import 'package:gupshop/bazaarProductDetails/reviewBuilderAndDisplay.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToChangeName.dart';
import 'package:gupshop/navigators/navigateToFullScreenPictureAndVideos.dart';
import 'package:gupshop/navigators/navigateToHome.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/imageConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';
import 'package:gupshop/retriveFromFirebase/retriveLikesDislikesFromBazaarRatingNumbers.dart';
import 'package:gupshop/video/videoThumbnailHelper.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class ProductDetail extends StatefulWidget {
  final String productWalaName;
  final String category;
  final String categoryData;
  final String productWalaNumber;
  final String subCategory;
  final String subCategoryData;
  final String homeServiceText;
  final bool homeServiceBool;
  final bool sendHome;


  ProductDetail({@required this.productWalaName, this.category, @required this.productWalaNumber,
    this.subCategory, this.subCategoryData, this.categoryData,
    this.homeServiceBool, this.homeServiceText, this.sendHome
  });

  @override
  _ProductDetailState createState() => _ProductDetailState(productWalaName: productWalaName, category: category);

}

class _ProductDetailState extends State<ProductDetail> with TickerProviderStateMixin{
  final String productWalaName;
  final String category;
  String userName;

  _ProductDetailState({@required this.productWalaName, this.category});

  String userNumber;
  bool writeReview;
  bool like=true;
  String reviewBody;
  bool likeOrDislike;
  String reviewNumberString;
  Timestamp timeStamp;

  CollectionReference collectionReference;
  Stream<QuerySnapshot> stream;


  bool focus;///when user taps on add review but does not want to send the review anymore
  ///he would tap on the screen

  int likes;
  int dislikes;


  getUserDetails()async {
    String name = await UserDetails().getUserNameFuture();
    String userNumberTemp = await UserDetails().getUserPhoneNoFuture();
    setState(() {
      userName = name;
      userNumber = userNumberTemp;
    });
  }


  @override
  void initState() {
    collectionReference = Firestore.instance.collection("bazaarReviews").document(widget.productWalaNumber).collection("reviews");
    stream = collectionReference.snapshots();

    getUserDetails();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(///---> used to block the user from going to bazaarProfilePage when he hits back button after creating a bazaar profile page
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
          child: ProductDetailsAppBar(
            productWalaName: widget.productWalaName,
            productWalaNumber: widget.productWalaNumber,
            userName: userName,
            sendHome: widget.sendHome,
            businessName: productWalaName,
            categoryData: widget.categoryData,
            subCategoryData: widget.subCategoryData,
            userPhoneNo: userNumber,
          ),
        ),
//        PreferredSize(
//          preferredSize: Size.fromHeight(WidgetConfig.appBarSeventy),
//          child: CustomAppBar(
//            title: CustomText(text: productWalaName,),
//            actions: <Widget>[
//              /// change bazaarwala name:
//              editName(),
//
//              /// chat bubble:
//              ChatWithBazaarwala(
//                bazaarwalaNumber: widget.productWalaNumber,
//                bazaarwalaName: widget.productWalaName,
//                userName: userName,
//                customContext:context,
//              ),
//            ],
//            onPressed: (){
//              if(widget.sendHome == true){
//                NavigateToHome(initialIndex: 1).navigateNoBrackets(context);
//              }else {
//                Navigator.pop(context);
//              }
//            }
//          ),
//        ),
        body: Flex(///---> Expanded has to be wrapped in Flex always
            direction: Axis.vertical,///---> this is the required property of Flex
            children: <Widget>[
          Expanded(///---> if not used, then child==_child is null error appears, hence we have to use Expanded
            child: _buildProductDetailsPage(context),
          ),
      ],
        ),
      ),
    );

  }



  /*
  Make video sliver viewable:
  To do that  we need to use SliverAppBar and put that video in the flexibleSpace of the sliverAppBar
  For, other widgets like reviews, ratings, we need to place them in SliverList
  IMP note : SliverAppBar can be used only in CustomScrollView
   */

  _buildProductDetailsPage(BuildContext context){
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          //title: buildProductImagesWidget(),
          leading: Container(),
          pinned: true,
          expandedHeight: WidgetConfig.sliverHeight,
          flexibleSpace: FlexibleSpaceBar(
            background: buildProductImagesWidget(),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[ //---> to decrease space  between review stars and reviews use Stack and wrap everything in it
              FutureBuilder(
                future: RetriveLikesAndDislikesFromBazaarRatingNumbers().numberOfLikesAndDislikes(widget.productWalaNumber, widget.categoryData,widget.subCategoryData ),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    likes = snapshot.data[TextConfig.likesBazaarRatingNumbers];
                    dislikes = snapshot.data[TextConfig.dislikesBazaarRatingNumbers];

                    return ReviewBuilderAndDisplay(productWalaName:productWalaName, productWalaNumber: widget.productWalaNumber,
                      category: widget.category,writeReview: writeReview,focus: focus,userName: userName,
                      reviewBody: reviewBody,likeOrDislike: likeOrDislike,likes: likes,dislikes: dislikes,
                      subCategory: widget.subCategory,subCategoryData: widget.subCategoryData,
                      categoryData: widget.categoryData, homeServiceText: widget.homeServiceText,
                      homeServiceBool: widget.homeServiceBool,
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ),

      ],
    );
  }

  buildProductImagesWidget(){
    TabController imagesController = new TabController(length: 4, vsync: this);

      return Card(
        child: FutureBuilder(
          future: GetBazaarWalasBasicProfileInfo(
              userNumber: widget.productWalaNumber,
            categoryData: widget.categoryData,
            subCategoryData: widget.subCategoryData
          ).getPictureListAndVideo(),/// get it from bazaarWalas basic profile and not videos collection
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              String videoURL = snapshot.data["videoURL"];

              String thumbnailPicture = snapshot.data["thumbnailPicture"];
              String otherPictureOne = snapshot.data["otherPictureOne"];
              String otherPictureTwo = snapshot.data["otherPictureTwo"];

              if(thumbnailPicture == null) thumbnailPicture = ImageConfig.photoFrame;


              if(otherPictureOne == null) otherPictureOne = ImageConfig.photoFrame;


              if(otherPictureTwo == null) otherPictureTwo = ImageConfig.photoFrame;


              return Center(
                child: Padding(
                  padding: EdgeInsets.all(PaddingConfig.sixteen),
                  child: Container(
                    height: WidgetConfig.productDetailImageHeight,
                    width: WidgetConfig().getProductDetailImageContainerWidth(context),
                    //MediaQuery.of(context).size.height / 2.75,
                    child: Center(
                      child: DefaultTabController(
                        length: 4,
                        child: Stack(
                          children: <Widget>[
                            TabBarView(
                              controller: imagesController,
                              children: <Widget>[
                                VideoThumbnailHelper(videoURL: videoURL, width: WidgetConfig().getChatMessageWidth(context), height: WidgetConfig().getChatMessageHeight(context)),
                                //CustomVideoPlayerThumbnail(videoURL: videoURL,),
                                //CustomVideoPlayer(videoURL: videoURL,),
                                buildImage(thumbnailPicture),
                                buildImage(otherPictureOne),
                                buildImage(otherPictureTwo),
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
                ),
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
          }
        ),
      );
  }

  buildImage(String imageURL) {
  return GestureDetector(
    child: Image(
      image: NetworkImage(imageURL),
      ),
    onTap: (){
      NavigateToFullScreenPictureAndVideos(isPicture: true, shouldZoom: true, payLoad: imageURL).navigateNoBrackets(context);
    },
  );
  }



}
