import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/bazaar/chatWithBazaarwala.dart';
import 'package:gupshop/bazaar/reviewBuilderAndDisplay.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToBazaarIndividualCategoryList.dart';
import 'package:gupshop/retriveFromFirebase/getBazaarWalasBasicProfileInfo.dart';
import 'package:gupshop/retriveFromFirebase/retriveLikesDislikesFromBazaarRatingNumbers.dart';
import 'package:gupshop/service/firestoreShortcuts.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customNavigators.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';

class ProductDetail extends StatefulWidget {
  final String productWalaName;
  final String category;
  final String productWalaNumber;


  ProductDetail({@required this.productWalaName, this.category, @required this.productWalaNumber});

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


  bool focus;//when user taps on add review but does not want to send the review anymore
  //he would tap on the screen

  int likes;
  int dislikes;


  getUserName()async {
    String name = await UserDetails().getUserNameFuture();
    setState(() {
      userName = name;
    });
  }


  @override
  void initState() {
    collectionReference = Firestore.instance.collection("bazaarReviews").document(widget.productWalaNumber).collection("reviews");
    stream = collectionReference.snapshots();

    getUserName();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(//---> used to block the user from going to bazaarProfilePage when he hits back button after creating a bazaar profile page
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: CustomAppBar(
            title: CustomText(text: 'Product Detail', fontSize: 20,),
            onPressed: (){
              //Navigator.pop(context);
              NavigateToBazaarIndiviudalCategoryList(category: category).navigateNoBrackets(context);
            }
          ),
        ),
        body: Flex(//---> Expanded has to be wrapped in Flex always
            direction: Axis.vertical,//---> this is the required property of Flex
            children: <Widget>[
          Expanded(//---> if not used, then child==_child is null error appears, hence we have to use Expanded
            child: _buildProductDetailsPage(context),
          ),
      ],
        ),
        floatingActionButton: ChatWithBazaarwala(
          bazaarwalaNumber: widget.productWalaNumber,
          bazaarwalaName: widget.productWalaName,
          userName: userName,
          userNumber: userNumber,
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
          expandedHeight: 260,
          flexibleSpace: FlexibleSpaceBar(
            background: buildProductImagesWidget(),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[ //---> to decrease space  between review stars and reviews use Stack and wrap everything in it
              FutureBuilder(
                future: RetriveLikesAndDislikesFromBazaarRatingNumbers().numberOfLikesAndDislikes(widget.productWalaNumber, widget.category),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    likes = snapshot.data['likes'];
                    dislikes = snapshot.data['dislikes'];

                    return ReviewBuilderAndDisplay(productWalaName:productWalaName, productWalaNumber: widget.productWalaNumber,
                      category: category,writeReview: writeReview,focus: focus,userName: userName,
                      reviewBody: reviewBody,likeOrDislike: likeOrDislike,likes: likes,dislikes: dislikes,
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

    return FutureBuilder(
      future: UserDetails().getUserPhoneNoFuture(),
      builder: (context, numberSnapshot) {
        userNumber = numberSnapshot.data;
        return Card(
          child: FutureBuilder(
            future: GetBazaarWalasBasicProfileInfo(userNumber: userNumber).getPictureListAndVideo(),/// get it from bazaarWalas basic profile and not videos collection
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done){
                String videoURL = snapshot.data["videoURL"];
                String thumbnailPicture = snapshot.data["thumbnailPicture"];
                String otherPictureOne = snapshot.data["otherPictureOne"];
                String otherPictureTwo = snapshot.data["otherPictureTwo"];

                if(thumbnailPicture == null) thumbnailPicture =
                "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/pictureFrame.png?alt=media&token=d1167b50-9af6-4670-84aa-93ea4d55a8d3";

                if(otherPictureOne == null) otherPictureOne =
                "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/pictureFrame.png?alt=media&token=d1167b50-9af6-4670-84aa-93ea4d55a8d3";

                if(otherPictureTwo == null) otherPictureTwo =
                "https://firebasestorage.googleapis.com/v0/b/gupshop-27dcc.appspot.com/o/pictureFrame.png?alt=media&token=d1167b50-9af6-4670-84aa-93ea4d55a8d3";

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 250.0,
                      child: Center(
                        child: DefaultTabController(
                          length: 4,
                          child: Stack(
                            children: <Widget>[
                              TabBarView(
                                controller: imagesController,
                                children: <Widget>[
                                  CustomVideoPlayer(videoURL: videoURL,),
                                  Image(
                                    image: NetworkImage(thumbnailPicture),
                                  ),
                                  Image(
                                    image: NetworkImage(otherPictureOne),
                                  ),
                                  Image(
                                    image: NetworkImage(otherPictureTwo),
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
              }else{
                return Center(child: CircularProgressIndicator());
              }
            }
          ),
        );
      }
    );
  }

}
