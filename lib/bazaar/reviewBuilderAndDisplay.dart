import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarReviewsCollection.dart';
import 'package:gupshop/bazaar/likesDislikesDisplay.dart';
import 'package:gupshop/bazaar/likesDislikesFetchAndDisplay.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/service/firestoreShortcuts.dart';
import 'package:gupshop/timestamp/timeDisplay.dart';
import 'package:gupshop/updateInFirebase/updateBazaarRatingNumbersCollection.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';

class ReviewBuilderAndDisplay extends StatefulWidget {
  String productWalaName;
  String category;
  String categoryData;
  String subCategory;
  bool writeReview;
  bool focus;
  String userName;
  String reviewBody;
  bool likeOrDislike;
  int likes;
  int dislikes;
  String productWalaNumber;
  final String subCategoryData;
  final String homeServiceText;
  final bool homeServiceBool;


  ReviewBuilderAndDisplay({this.productWalaName, this.productWalaNumber, this.category, this.writeReview,
    this.focus, this.userName, this.reviewBody, this.likeOrDislike, this.likes, this.dislikes,this.subCategory,
    this.subCategoryData, this.categoryData,this.homeServiceBool, this.homeServiceText,
  });


  @override
  _ReviewBuilderAndDisplayState createState() => _ReviewBuilderAndDisplayState();
}

class _ReviewBuilderAndDisplayState extends State<ReviewBuilderAndDisplay> with TickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  String userNumber;
  Timestamp timeStamp;
  bool likeClicked;
  bool dislikeClicked;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: new ScrollController(),//---> for scrolling the screen
      shrinkWrap: true,//---> Vertical viewport was given unbounded height.- this error thrown if not used
      children: <Widget>[
        /// category
        Padding(
          padding: EdgeInsets.only(left:8.0),
          child: CustomText( text : widget.category,).bigFont(),
        ),
        /// subcategories
        Visibility(
          visible: widget.subCategory != null,
          child: Padding(
            padding: EdgeInsets.only(left:8.0),
            child: CustomText(text : widget.subCategory,).subTitle(),
          ),
        ),
        Visibility(
          visible: widget.homeServiceBool != null,
          child: Padding(
            padding: EdgeInsets.only(left:8.0),
            child: CustomText(text : widget.homeServiceText,).blueSubtitle(),
          ),
        ),
        likeDislikeIconsAndAddReviewButton(3),
        if (widget.writeReview==true && widget.focus==false) _writeReview(),
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());/// not working
              widget.focus=true;
          },
          child:  _buildReviewList(context),
        ),

      ],
    );
  }

  _writeReview(){
    return Row(
      children: <Widget>[
        Row(
          children: <Widget>[
            _isLike(),
            _isDislike(),
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: WidgetConfig.reviewWidth),
          child: Padding(
            padding: EdgeInsets.only(left: 14),//---> for distance between left side of the screen and the review writing text bar
            child: _sendReview(),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            if((likeClicked == null || likeClicked == true) && (dislikeClicked == null || dislikeClicked == false)){
              /// first time when the user has not given any reviews, then
              /// likeClicked would be null, and likes would also be null,
              /// hence checking that condition
              if(likeClicked == null){
                setState(() {
                  widget.likes = 1;
                  widget.writeReview= false;
                  likeClicked = true;
                });
              }
              else setState(() {
                widget.likes++;
                widget.writeReview= false;///to show the non textField view again, where we have only the reviews
              });
            } else {
              setState(() {
                widget.dislikes++;
                widget.writeReview= false;///to show the non textField view again, where we have only the reviews
              });

            }


            if(_formKey.currentState.validate()){
              var data =  {
                "reviewerName":widget.userName,
                "body":widget.reviewBody,
                "like":likeClicked,
                "dislike":dislikeClicked,
                "timestamp":Timestamp.now(),
              };

              if(widget.likes == null) widget.likes =0;
              if(widget.dislikes == null) widget.dislikes =0;

              PushToBazaarReviewsCollection().addReview(widget.productWalaNumber, widget.categoryData, data);
              UpdateBazaarRatingNumberCollection(productWalaNumber: widget.productWalaNumber, category: widget.categoryData, likes: widget.likes, dislikes: widget.dislikes).updateRatings();
            }
          },
        ),
      ],
    );
  }

  _isLike(){
    return Padding(
      padding: EdgeInsets.only(left:8.0),
      child: GestureDetector(
          onTap: (){
            setState(() {
              //widget.likes++;
              likeClicked=true;
              dislikeClicked = false;
              //widget.likeOrDislike=true;
            });
          },
          child: Container(
            height: WidgetConfig.likeDislikeContainer,
            width: WidgetConfig.likeDislikeContainer,
            color: likeClicked == true ? Colors.grey : Colors.transparent,
            child: Text('👍'),
          )
      ),
    );
  }

  _isDislike(){
    return Padding(
      padding: EdgeInsets.only(left:8.0),
      child: GestureDetector(
        onTap: (){
          setState(() {
            //widget.dislikes++;
            dislikeClicked = true;
            print("dislikeClicked :$dislikeClicked");
            likeClicked=false;
            //widget.likeOrDislike=false;
          });
        },
        child: Container(
            height: WidgetConfig.likeDislikeContainer,
            width: WidgetConfig.likeDislikeContainer,
            color: dislikeClicked == true ? Colors.grey : Colors.transparent,
            child: Text('👎')
        ),
      ),
    );
  }

  _sendReview(){
    return Form(// a form gives
      key: _formKey,
      child: TextFormField(
        validator: (value){
          if(value.isEmpty) return 'Please write your review';
          else{
            widget.reviewBody=value;//---> else this TextFormField was returning null and reviewBody was  getting  assigned null value; hence, we manually assigned the value of 'value' to reviewbody
            return null;
          }
        },
        maxLines: null,
      ),
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
                future: FirestoreShortcuts().getVideoURL(widget.productWalaNumber),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                    String videoURL = snapshot.data["url"];
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          height: WidgetConfig.productDetailImageHeight,
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
                                        image: AssetImage('images/sampleProfilePicture.jpeg'),
                                      ),
                                      Image(
                                        image: AssetImage('images/sampleImageForBazaar.jpeg'),
                                      ),
                                      Image(
                                        image: AssetImage('images/kamwali.png'),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    alignment: FractionalOffset(0.5,0.95),//placing the tabpagSelector at the bottom  center of the container
                                    child: TabPageSelector(
                                      controller: imagesController,//if this is not used then the images move but the tabpageSelector does not change the color of the tabs showing which image it is on
                                      selectedColor: Colors.grey,//default color is blue
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
                    // If the VideoPlayerController is still initializing, show a
                    // loading spinner.
                    return Center(child: CircularProgressIndicator());
                  }

                }
            ),
          );
        }
    );
  }


  _buildReviewList(context){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          widget.focus=true;
        });
      },
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("bazaarReviews").document(widget.productWalaNumber).collection(widget.categoryData).orderBy("timestamp", descending: true).snapshots(),
              builder: (context, snapshot) {
                if(snapshot.data == null) return CircularProgressIndicator();

                int lengthOfReviews = snapshot.data.documents.length;

                if(snapshot.data == null) return CircularProgressIndicator();

                return snapshot.data.documents == null ? Center(child: CustomText(text: 'No reviews yet',)):/// not showing up
                NotificationListener<ScrollUpdateNotification>(
                  child: ListView.separated(
                    shrinkWrap: true,///throws exception if not used
                    controller: new ScrollController(),///for scrolling screen
                    itemCount: lengthOfReviews,
                    itemBuilder: (context, index){
                      String reviewerName = snapshot.data.documents[index].data["reviewerName"];
                      String reviewText = snapshot.data.documents[index].data["body"];
                      bool like = snapshot.data.documents[index].data["like"];
                      bool dislike = snapshot.data.documents[index].data["dislike"];
                      timeStamp = snapshot.data.documents[index].data["timestamp"];
                      return ListTile(
                        title: Text(reviewerName,style: GoogleFonts.openSans()),
                        subtitle: Text(reviewText,style: GoogleFonts.openSans()),
                        trailing: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            TimeDisplay(timeStamp: timeStamp,),
                            LikesDislikesDisplay(like: like, dislike: dislike,).likesDislikesIconButton(),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white,
                    ),
                  ),
                );
              }
          ),
        ],
      ),
    );
  }


  likeDislikeIconsAndAddReviewButton(int rating){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,//for spacing between rating stars and add review
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child: LikesDislikesFetchAndDisplay(productWalaNumber: widget.productWalaNumber, category: widget.categoryData, subCategory: widget.subCategory,)
            //_buildRatingStars(3),
          ),
          widget.userName != widget.productWalaName ?
          Container(
            padding: EdgeInsets.only(left:5, right: 5),//for spacing bewteen Add review text from left and right side of the blue container
            child: CustomRaisedButton(
              child: CustomText(
                text: 'Add Review',).subTitle(),
              onPressed: (){
                setState(() {
                  widget.writeReview = true;
                  widget.focus = false;
                });
              },),
            alignment: Alignment.center,
          ) : Container(
            padding: EdgeInsets.only(left:5, right: 5),//for spacing bewteen Add review text from left and right side of the blue container
            child: CustomRaisedButton(
              child: CustomText(
                text: 'Change Advertisement', fontSize: 12,),
              onPressed: (){
                /// take the bazaarWala to bazaarProfile page"
//                NavigateToBazaarProfilePage().navigateNoBrackets(context);
              },),
//            Text('Add your advertisement',style: GoogleFonts.openSans(
//                fontSize: 12
//            )),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(1),
            ),
          ),

        ],
      ),
    );
  }
}
