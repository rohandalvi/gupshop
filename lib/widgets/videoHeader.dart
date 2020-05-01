//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/src/rendering/sliver_persistent_header.dart';
//
//
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
//import 'package:gupshop/models/message_model.dart';
//import 'package:gupshop/widgets/videoHeader.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:video_player/video_player.dart';
//import 'package:intl/intl.dart';
//
//class VideoHeader extends State<StatefulWidget> with TickerProviderStateMixin implements SliverPersistentHeaderDelegate{
//  final double minExtent;
//  final double maxExtent;
//
//  VideoHeader({@required this.maxExtent, this.minExtent});
//
//
//  VideoPlayerController playerController;
//  Future<void> _initializeVideoPlayerFuture;
//
//
//  @override
//  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//    return Stack(
//
//    );
//
//  }
//
//  @override
//  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//    // TODO: implement shouldRebuild
//    return null;
//  }
//
//  @override
//  // TODO: implement snapConfiguration
//  FloatingHeaderSnapConfiguration get snapConfiguration => null;
//
//  @override
//  // TODO: implement stretchConfiguration
//  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;
//
//
//  _buildProductImagesWidget(){
//    TabController imagesController = new TabController(length: 3, vsync: this);
//
//    print("playerController: $playerController");
//    return Card(
//      child: FutureBuilder(
//          future: _initializeVideoPlayerFuture,
//          builder: (context, snapshot) {
//            if(snapshot.connectionState == ConnectionState.done){
//              // If the VideoPlayerController has finished initialization, use
//              // the data it provides to limit the aspect ratio of the VideoPlayer.
//              return Center(
//                child: Padding(
//                  padding: const EdgeInsets.all(16.0),
//                  child: Container(
//                    height: 250.0,
//                    child: Center(
//                      child: DefaultTabController(
//                        length: 3,
//                        child: Stack(
//                          children: <Widget>[
//                            TabBarView(
//                              controller: imagesController,
//                              children: <Widget>[
//                                playerController != null  ? VideoPlayer(playerController) :
//                                Image(
//                                  image: AssetImage('images/sampleProfilePicture.jpeg'),
////                  image: NetworkImage('https://youtu.be/EngW7tLk6R8'),
//                                ),
//                                Image(
//                                  image: AssetImage('images/sampleImageForBazaar.jpeg'),
//                                ),
//                                Image(
//                                  image: AssetImage('images/kamwali.png'),
//                                ),
//                              ],
//                            ),
//                            FloatingActionButton(
//                              onPressed: () {
//                                // Wrap the play or pause in a call to `setState`. This ensures the
//                                // correct icon is shown
//                                setState(() {
//                                  // If the video is playing, pause it.
//                                  if (playerController.value.isPlaying) {
//                                    playerController.pause();
//                                  } else {
//                                    // If the video is paused, play it.
//                                    playerController.play();
//                                  }
//                                });
//                              },
//                              // Display the correct icon depending on the state of the player.
//                              child: Icon(
//                                playerController.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                              ),
//                            ),
//                            Container(
//                              alignment: FractionalOffset(0.5,0.95),//placing the tabpagSelector at the bottom  center of the container
//                              child: TabPageSelector(
//                                controller: imagesController,//if this is not used then the images move but the tabpageSelector does not change the color of the tabs showing which image it is on
//                                selectedColor: Colors.grey,//default color is blue
//                                color: Colors.white,
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              );
//            }else{
//              // If the VideoPlayerController is still initializing, show a
//              // loading spinner.
//              return Center(child: CircularProgressIndicator());
//            }
//
//          }
//      ),
//    );
//  }
//
//}