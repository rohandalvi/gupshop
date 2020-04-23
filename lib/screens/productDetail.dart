import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class ProductDetail extends StatefulWidget {
  @override
  _ProductDetailState createState() => _ProductDetailState();

}

class _ProductDetailState extends State<ProductDetail> with TickerProviderStateMixin{
  VideoPlayerController playerController;
  Future<void> _initializeVideoPlayerFuture;

  String userNumber= '+919870725050';

  @override
  void initState() {
    playerController = VideoPlayerController.asset('videos/LevenworthVideo.mp4');
    _initializeVideoPlayerFuture = playerController.initialize();

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    playerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildProductDetailsPage(context),
    );
  }

  _buildProductDetailsPage(BuildContext context){
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            Container(
              child: Card(
                elevation: 4.0,//shadow of the box
                child: Column(
                  children: <Widget>[
                    _buildProductImagesWidget(),
                    _showRatings(3),
//                _buildReviewsWithAlbum(),
                    _buildReviewList(context),
                  ],
                ),
              ),
            ),
          ],
        ),
        _floatingActionButtonForMessaging(),//for messaging chat button on the right bottom
      ],
    );
  }


  _buildProductImagesWidget(){
    TabController imagesController = new TabController(length: 3, vsync: this);

    print("playerController: $playerController");
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the VideoPlayer.
          return Center(
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
                            playerController != null  ? VideoPlayer(playerController) :
                            Image(
                              image: AssetImage('images/sampleProfilePicture.jpeg'),
//                  image: NetworkImage('https://youtu.be/EngW7tLk6R8'),
                            ),
                            Image(
                              image: AssetImage('images/sampleImageForBazaar.jpeg'),
                            ),
                            Image(
                              image: AssetImage('images/kamwali.png'),
                            ),
                          ],
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            // Wrap the play or pause in a call to `setState`. This ensures the
                            // correct icon is shown
                            setState(() {
                              // If the video is playing, pause it.
                              if (playerController.value.isPlaying) {
                                playerController.pause();
                              } else {
                                // If the video is paused, play it.
                                playerController.play();
                              }
                            });
                          },
                          // Display the correct icon depending on the state of the player.
                          child: Icon(
                            playerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
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
    );
  }

  
  _buildReviewList(BuildContext context){
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection("bazaarReviews").document(userNumber).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.data == null) return CircularProgressIndicator();
            print("snapshot.data.documentID: ${snapshot.data.data}");
            int numberOfReviews = snapshot.data.data.length;

            return NotificationListener<ScrollUpdateNotification>(
              child: ListView.separated(
                shrinkWrap: true,//throws exception if not used
                controller: new ScrollController(),//for scrolling screen
                itemCount: numberOfReviews,
                itemBuilder: (context, index){
                  print("revirwerName: ${snapshot.data.data["reviews"][index]["ReviewerName"]}");
                  String reviewerName = snapshot.data.data["reviews"][index]["ReviewerName"];
                  String reviewText = snapshot.data.data["reviews"][index]["body"];
                  bool likeOrDislike = snapshot.data.data["reviews"][index]["likeOrDislike"];
                  return ListTile(
                    title: Text(reviewerName,style: GoogleFonts.openSans()),
                    subtitle: Text(reviewText,style: GoogleFonts.openSans()),
                    trailing: _buildLikeOrDislike(likeOrDislike),
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
    );
  }

  _floatingActionButtonForMessaging(){
    return Padding(
      padding: const EdgeInsets.all(20.0),//if this is not used, the chat floating action button appears sticking to the right end  of the screen
      child: Align(
          alignment: Alignment.bottomRight,
          child:
          //scrollListener() ?
          FloatingActionButton(
            child: IconButton(
              icon: Icon(Icons.chat_bubble_outline),
            ),
            onPressed: (){
            },
          )
        //: new Align(),
      ),
    );
  }

  _buildRatingStars(int rating){
    String stars = '';
    for(int i =0; i<rating; i++){
      stars += '⭐️';
    }
    stars.trim();
    return Text(stars);

  }

  _buildLikeOrDislike(bool likeOrDislike){
    if (likeOrDislike = true){
      return Text('👍');
    } return Text ('👎');
  }

  _showRatings(int rating){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Align(
              alignment: Alignment.centerLeft,
              child: _buildRatingStars(3),
          ),
          IconButton(icon: Icon(Icons.add),),
        ],
      ),
    );
  }
}
