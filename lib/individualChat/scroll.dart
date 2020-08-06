import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gupshop/individualChat/bodyPlusScrollComposerData.dart';

class Scroll extends StatefulWidget {
  bool scroll = false;
  ScrollController listScrollController = new ScrollController(); //for scrolling the screen

  @override
  _ScrollState createState() => _ScrollState();
}

class _ScrollState extends State<Scroll> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        /// ScrollUpdateNotification :
        /// for listining when the user scrolls up
        /// Show the scrolltobottom button only when the user scrolls up
        print("notification: $notification");
        if(notification is ScrollUpdateNotification){
          /// *** explaintaion of if(notification.scrollDelta > 0):
          /// The problem we has was, setting the state of scroll to false in
          /// _scrollToTheBottom methos was making the scroll false, but while
          /// scrolling down there used to be another update on ScrollUpdateNotification
          /// and it would again set the scroll to true in setState
          /// So we had to figure out a way to set the state to true only when the
          /// user is scrolling up.
          /// if(notification.scrollDelta > 0):
          ///if we print notification, then we can note that if the screen scrolls
          ///down then the scrollDelta shows in minus.
          //someone from stackoverflow said :
          //if (scrollNotification.metrics.pixels - scrollNotification.dragDetails.delta.dy > 0)
          //but this was giving us error that delta was called on null, so i used :
          //if(notification.scrollDelta > 0)
          if(notification.scrollDelta > 0){
            setState(() {
              widget.scroll = true;
              print("scroll: ${widget.scroll}");
            });
          }


          ///scroll button to disappear when the user goes down manually
          ///without pressing the scrollDown button
          if(notification.metrics.atEdge
              &&  !((notification.metrics.pixels - notification.metrics.maxScrollExtent) >
                  (notification.metrics.minScrollExtent-notification.metrics.pixels))){
            setState(() {
              widget.scroll = false;
            });
          }
        }

        ///onNotification allows us to know when we have reached the limit of the messages
        ///once the limit is reached, documentList is updated again  with the next 10 messages using
        ///the fetchAdditionalMesages()
//        if(notification.metrics.atEdge
//            &&  !((notification.metrics.pixels - notification.metrics.minScrollExtent) <
//                (notification.metrics.maxScrollExtent-notification.metrics.pixels))) {
//
////                        if(isLoading == true) {//ToDo- check if this is  working with an actual phone
////                          CircularProgressIndicator();}
//          setState(() {
//            limitCounter++;
//          });
//          //fetchAdditionalMessages();
//        }
        return true;
      },
      child: BodyPlusScrollComposerData(),
    );
  }

  _scrollToBottomButton(){///the button with down arrow that should appear only when the user scrolls
    return Visibility(/// a placeholder widget isValid widget
      visible: widget.scroll,
      child: Align(
          alignment: Alignment.centerRight,
          child:
          //scrollListener() ?
          FloatingActionButton(
            tooltip: 'Scroll to the bottom',
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            child: IconButton(
                icon: SvgPicture.asset('images/downArrow.svg',)
            ),
            onPressed: (){
              setState(() {
                widget.scroll = false;
              });
              widget.listScrollController.animateTo(//for scrolling to the bottom of the screen when a next text is send
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 300),
              );
            },
          )
        //: new Align(),
      ),
    );
  }
}
