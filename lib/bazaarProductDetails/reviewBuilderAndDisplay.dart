import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/PushToFirebase/pushToBazaarReviewsCollection.dart';
import 'package:gupshop/bazaarOnBoarding/onBoardingHome.dart';
import 'package:gupshop/bazaarProductDetails/likesDislikesDisplay.dart';
import 'package:gupshop/bazaarProductDetails/likesDislikesFetchAndDisplay.dart';
import 'package:gupshop/responsive/intConfig.dart';
import 'package:gupshop/responsive/navigatorConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/responsive/widgetConfig.dart';
import 'package:gupshop/retriveFromFirebase/bazaarReviewsCollection.dart';
import 'package:gupshop/timestamp/timeDisplay.dart';
import 'package:gupshop/updateInFirebase/updateBazaarRatingNumbersCollection.dart';
import 'package:gupshop/widgets/customRaisedButton.dart';
import 'package:gupshop/widgets/customText.dart';

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
          padding: EdgeInsets.only(left:PaddingConfig.eight),
          child: CustomText( text : widget.category,).bigFont(),
        ),
        /// subcategories
        Visibility(
          visible: widget.subCategory != null,
          child: Padding(
            padding: EdgeInsets.only(left:PaddingConfig.eight),
            child: CustomText(text : widget.subCategory,).subTitle(),
          ),
        ),
        Visibility(
          visible: widget.homeServiceBool != null,
          child: Padding(
            padding: EdgeInsets.only(left:PaddingConfig.eight),
            child: widget.homeServiceBool == null ? CustomText(text: ":)",) :CustomText(text : widget.homeServiceText,).blueSubtitle(),/// A non-null String must be provided to a Text widget. error was thrown
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
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              _isLike(),
              _isDislike(),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: GestureDetector(
            /// when user clicks on screen to let go off the keyboard
            onTap: () {
              FocusScope.of(context).unfocus();/// not working
//              FocusScope.of(context).requestFocus(new FocusNode());/// not working
              widget.focus=true;
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: WidgetConfig.reviewWidth),
              child: Padding(
                padding: EdgeInsets.only(left: PaddingConfig.fourteen),//---> for distance between left side of the screen and the review writing text bar
                child: _sendReview(),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: IconButton(
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

                PushToBazaarReviewsCollection(subCategory: widget.subCategoryData).addReview(widget.productWalaNumber, widget.categoryData, data);
                UpdateBazaarRatingNumberCollection(productWalaNumber: widget.productWalaNumber, categoryData: widget.categoryData, likes: widget.likes, dislikes: widget.dislikes, subCategoryData: widget.subCategoryData, data: data).updateRatings();
              }
            },
          ),
        ),
      ],
    );
  }

  _isLike(){
    return Padding(
      padding: EdgeInsets.only(left:PaddingConfig.eight),
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
      padding: EdgeInsets.only(left:PaddingConfig.eight),
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
          if(value.isEmpty) return TextConfig.bazaarWriteReview;
          else{
            widget.reviewBody=value;//---> else this TextFormField was returning null and reviewBody was  getting  assigned null value; hence, we manually assigned the value of 'value' to reviewbody
            return null;
          }
        },
        maxLines: null,
        maxLength: IntConfig.textFormFieldLimitOneFifty,
      ),
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
              stream: BazaarReviewsCollection(productWalaNumber: widget.productWalaNumber,
                  categoryData: widget.categoryData, subCategoryData: widget.subCategoryData,
              ).getOrderedStream(),
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
                        title: Container(child: CustomText(text: reviewerName,)),
                        //Text(reviewerName,style: GoogleFonts.openSans()),
                        subtitle: Container(child: CustomText(text: reviewText).subTitle(),),
                          //Text(reviewText,style: GoogleFonts.openSans()),
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


  /// add Review/ edit Profile
  likeDislikeIconsAndAddReviewButton(int rating){
    print("in likeDislikeIconsAndAddReviewButton");
    return Padding(
      padding: EdgeInsets.all(PaddingConfig.five),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,//for spacing between rating stars and add review
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child: LikesDislikesFetchAndDisplay(productWalaNumber: widget.productWalaNumber, categoryData: widget.categoryData, subCategoryData: widget.subCategoryData,)
            //_buildRatingStars(3),
          ),
          widget.userName != widget.productWalaName ?
          Container(
            padding: EdgeInsets.only(left:PaddingConfig.five, right: PaddingConfig.five),//for spacing bewteen Add review text from left and right side of the blue container
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
            padding: EdgeInsets.only(left:PaddingConfig.five, right: PaddingConfig.five),//for spacing bewteen Add review text from left and right side of the blue container
            child: CustomRaisedButton(
              child: CustomText(
                text: 'Edit Profile', fontSize: WidgetConfig.fontSizeTwelve,),
              onPressed: (){
                /// take the bazaarWala to bazaarProfile page"

                Map<String,dynamic> navigatorMap = new Map();
                navigatorMap[TextConfig.text] = "Select a category to edit";

                Navigator.pushNamed(context, NavigatorConfig.bazaarOnBoardingHome, arguments: navigatorMap);

//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => Material(child: OnBoardingHome(
//                          text : "Select a category to edit")),
//                    )
//                );
              },),
//            Text('Add your advertisement',style: GoogleFonts.openSans(
//                fontSize: 12
//            )),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(WidgetConfig.borderRadiusOne),
            ),
          ),

        ],
      ),
    );
  }
}
