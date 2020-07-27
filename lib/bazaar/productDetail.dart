import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gupshop/bazaar/bazaarFirestoreShortcuts.dart';
import 'package:gupshop/bazaar/likesDislikesFetchAndDisplay.dart';
import 'package:gupshop/retriveFromFirebase/retriveLikesDislikesFromBazaarRatingNumbers.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/bazaar/bazaarIndividualCategoryList.dart';
import 'package:gupshop/service/firestoreShortcuts.dart';
import 'package:gupshop/widgets/customAppBar.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/customVideoPlayer.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';

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


  VideoPlayerController playerController;
  Future<void> _initializeVideoPlayerFuture;

  String userNumber;
  bool writeReview;
  bool like=true;
  String reviewBody;
  bool likeOrDislike;
  String reviewNumberString;
  Timestamp timeStamp;

  CollectionReference collectionReference;
  Stream<QuerySnapshot> stream;

  final _formKey = GlobalKey<FormState>();//for sendReview()

  bool focus;//when user taps on add review but does not want to send the review anymore
  //he would tap on the screen

  int likes;
  int dislikes;



//  void initState() {
//    //adding collectionReference and stream in initState() is essential for making the autoscroll when messages hit the limit
//    //when user scrolls
//    collectionReference = Firestore.instance.collection("conversations").document(conversationId).collection("messages");
//    stream = collectionReference.orderBy("timeStamp", descending: true).limit(10).snapshots();
//
////    listScrollController = ScrollController();//ToDo - here
////    listScrollController.addListener(scrollListener());
//
//    super.initState();
//  }


  getUserName()async {
    String name = await UserDetails().getUserNameFuture();
    setState(() {
      userName = name;
    });
  }


  @override
  void initState() {
    playerController = VideoPlayerController.asset('videos/LevenworthVideo.mp4');
    _initializeVideoPlayerFuture = playerController.initialize();

    collectionReference = Firestore.instance.collection("bazaarReviews").document(widget.productWalaNumber).collection("reviews");
    stream = collectionReference.snapshots();

    getUserName();

//    numberOfDislikes();
//    numberOfLikes();

    super.initState();
  }

//  @override
//  void dispose() {
//    // Ensure disposing of the VideoPlayerController to free up resources.
//    playerController.dispose();
//
//    super.dispose();
//  }

  goToBazaarIndividualCategoryListPage() async{
    print("in onWillPop");
    await
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) {
          return BazaarIndividualCategoryList();
        },
      ),
          (Route<dynamic> route) => false,
    );
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
              Navigator.pop(context);
            }
            //NavigateToBazaarIndiviudalCategoryList(category: category).navigate(context),
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
        floatingActionButton: _floatingActionButtonForMessaging(),
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
            <Widget>[//---> to decrease space  between review stars and reviews use Stack and wrap everything in it
              ListView(
                controller: new ScrollController(),//---> for scrolling the screen
                shrinkWrap: true,//---> Vertical viewport was given unbounded height.- this error thrown if not used
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left:8.0),
                    child: Text(productWalaName,style: GoogleFonts.openSans(
                      fontSize: 20,
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:8.0),
                    child: Text(category,style: GoogleFonts.openSans(
                      color: Colors.grey,
                      fontSize: 13,
                    )),
                  ),
                  _showRatings(3),
                  //numberOfLikesDislikes(),
                  if (writeReview==true && focus==false) _writeReview(),
                  _buildReviewList(context),
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }


  _writeReview(){
    print("like or not like? : $like");
    return Row(
      children: <Widget>[
          Row(
            children: <Widget>[
              _isLike(),
              _isDislike(),
            ],
          ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 280),
          child: Padding(
            padding: EdgeInsets.only(left: 14),//---> for distance between left side of the screen and the review writing text bar
            child: _sendReview(),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            print("userName in iconButton: $userName");

            if(_formKey.currentState.validate()){
              setState(() {
                var data =  {
                  "reviewerName":userName,
                  "body":reviewBody,
                  "likeOrDislike":likeOrDislike,
                  "timestamp":DateTime.now(),
                };

                if(likes == null) likes =0;
                if(dislikes == null) dislikes =0;

                if(likeOrDislike == null || likeOrDislike == true){
                  setState(() {
                    likes++;
                  });
                } else dislikes++;
                //---> pushing review data to firebase bazaarReviews collection:
                print("data: $data");
                //print("what is : ${Firestore.instance.collection("bazaarReviews").document(userNumber).collection("reviews").document().setData(data)}");
                BazaarFirestoreShortcuts().addReviewToBazaarReviewsCollection(widget.productWalaNumber, category, data);

                BazaarFirestoreShortcuts().updateRatingsInBazaarRatingNumbers(widget.productWalaNumber, category, likes, dislikes);

                print("likeDislike befoew setting state: $likeOrDislike ");
                writeReview= false;///to show the non textField view again, where we have only the reviews
                like = true;///setting the like and dislike's state as false again, to make them appear on the review bar again
                //disLike = false;
                print("likeDislike befoew after state: $likeOrDislike ");
              });
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
              //likes++;
              like=true;
              likeOrDislike=true;
            });
          },
          child: Container(
            height: 20,
            width: 20,
            color: like == true ? Colors.grey : Colors.transparent,
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
            dislikes++;
            like=false;
            likeOrDislike=false;
            print("likedislike in dislike==false: $likeOrDislike");
          });
        },
        child: Container(
            height: 20,
            width: 20,
            color: like == false ? Colors.grey : Colors.transparent,
            child: Text('👎')
        ),
      ),
    );
  }

  _sendReview(){
    print("inside form");
  return Form(// a form gives
    key: _formKey,
    child: TextFormField(
      validator: (value){
        if(value.isEmpty) return 'Please write your review';
        else{
          reviewBody=value;//---> else this TextFormField was returning null and reviewBody was  getting  assigned null value; hence, we manually assigned the value of 'value' to reviewbody
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

  
  _buildReviewList(BuildContext context){
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          focus=true;
        });
      },
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            //.orderBy("timestamp", descending: true)
            stream: Firestore.instance.collection("bazaarReviews").document(widget.productWalaNumber).collection(category).snapshots(),
            //Firestore.instance.collection("bazaarReviews").document(userNumber).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.data == null) return CircularProgressIndicator();
              print("what is this : $stream");
              //Firestore.instance.collection("bazaarReviews").document(userNumber).collection("reviews").snapshots();

              print("document is : ${snapshot.data.documents}");
              int lengthOfReviews = snapshot.data.documents.length;

              if(snapshot.data == null) return CircularProgressIndicator();
//            print("snapshot.data.data: ${snapshot.data.data}");
//            int numberOfReviews = snapshot.data.data.length;

              return snapshot.data.documents == null ? Center(child: CustomText(text: 'No reviews yet',)):/// not showing up
              NotificationListener<ScrollUpdateNotification>(
                child: ListView.separated(
                  shrinkWrap: true,//throws exception if not used
                  controller: new ScrollController(),//for scrolling screen
                  itemCount: lengthOfReviews,
                  itemBuilder: (context, index){
                    print("revirwerName: ${snapshot.data.documents[index].data["reviewerName"]}");
                    String reviewerName = snapshot.data.documents[index].data["reviewerName"];
                    String reviewText = snapshot.data.documents[index].data["body"];
                    bool likeOrDislike = snapshot.data.documents[index].data["likeOrDislike"];
                    timeStamp = snapshot.data.documents[index].data["timestamp"];
                    print("timestamp: $timeStamp");
                    return ListTile(
                      title: Text(reviewerName,style: GoogleFonts.openSans()),
                      subtitle: Text(reviewText,style: GoogleFonts.openSans()),
                      trailing: Wrap(
                        children: <Widget>[
                          _timeMaker(),
                          _buildLikeOrDislike(likeOrDislike),
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


  _timeMaker(){
    return Text(//time
        DateFormat("dd MMM kk:mm")
            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp.millisecondsSinceEpoch.toString()))),//converting firebase timestamp to pretty print
        style: TextStyle(
        color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic
        )
    );
  }

  _floatingActionButtonForMessaging(){
    return FloatingActionButton(
      heroTag: "button2",
      child: IconButton(
        icon: Icon(Icons.chat_bubble_outline),
      ),
      onPressed: (){
      },
    );
  }



///number of ratings
  _buildRatingStars(int rating){
    return Row(
            children: <Widget>[
              FutureBuilder(
                future: RetriveLikesAndDislikesFromBazaarRatingNumbers().numberOfLikes(widget.productWalaNumber, category),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    likes = snapshot.data;
                    if(likes == null) likes = 0;
                    return  Container(//wrapped in a container becuase if later the number of likes or  dislikes  become hummungus then it would not overflow
                        child: Row(
                          children: <Widget>[
                            Text('👍'),
                            Text(likes.toString()),
                          ],
                        )
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              FutureBuilder(
                future: RetriveLikesAndDislikesFromBazaarRatingNumbers().numberOfDislikes(widget.productWalaNumber, category),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    dislikes = snapshot.data;
                    if(dislikes == null) dislikes = 0;
                    return
                      Container(
                          padding: EdgeInsets.only(left: 12),
                          child: Row(
                            children: <Widget>[
                              Text('👎'),
                              Text(dislikes.toString()),
                            ],
                          )
                      );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ],
          );
        }


  _buildLikeOrDislike(bool likeOrDislike){
    if (likeOrDislike == null || likeOrDislike == true){
      return Text('👍');
    } return Text ('👎');
  }



  _showRatings(int rating){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,//for spacing between rating stars and add review
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child: LikesDislikesFetchAndDisplay(productWalaNumber: widget.productWalaNumber, category: widget.category,)
              //_buildRatingStars(3),
          ),
          //IconButton(icon: Icon(Icons.add),),
          GestureDetector(
            onTap: (){
              setState(() {
                writeReview = true;
                focus = false;
              });
            },
            child: userName != productWalaName ?
             Container(
              padding: EdgeInsets.only(left:5, right: 5),//for spacing bewteen Add review text from left and right side of the blue container
              child: Text('Add review',style: GoogleFonts.openSans(
                fontSize: 12
              )),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ) : Container(
              padding: EdgeInsets.only(left:5, right: 5),//for spacing bewteen Add review text from left and right side of the blue container
              child: Text('Add your advertisement',style: GoogleFonts.openSans(
                  fontSize: 12
              )),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

        ],
      ),
    );
  }

//  numberOfLikes() async{
//    await Firestore.instance.collection("bazaarRatingNumbers").document(widget.productWalaNumber).get().then((val){
//      setState(() {
//        likes= val.data["dislikes"];
//      });
//      print("dislikes: $dislikes");
//    });
//  }
//
//  numberOfDislikes() async{
//    print("widget.productWalaNumber in numberOfDislikes: ${widget.productWalaNumber}");
//    DocumentSnapshot dc =  await Firestore.instance.collection("bazaarRatingNumbers").document(widget.productWalaNumber).get();
//    print("dislikes: ${dc.data}");
//    setState(() {
//      dislikes= dc.data["dislikes"];
//    });
//
//  }





  //Future<String>  getUserName() async {
//    await Firestore.instance.collection("users").document(myNumber).get().then((val){
//      return val.toString();
//    });
//  }
}
