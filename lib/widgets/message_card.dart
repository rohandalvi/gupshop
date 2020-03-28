import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/models/message_model.dart';

class MessageCard extends StatefulWidget {
  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      //Expanded==>if this is  not included then nothing will show on the screen
      child: Container(
        child: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(//Row==>big outer rectangle of the latest chat
              mainAxisAlignment: MainAxisAlignment.spaceBetween,//To keep the timestamp and New right aligned no matter how big the text message gets
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SizedBox(width: 10,),//For the Alignment from the left side of the phone screen
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,//vertical space between the dispay pics
                      ),
                      child: CircleAvatar(//first column of the Row
                        radius: 35.0,
                        backgroundImage: AssetImage(chats[index].sender.imageUrl),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(//for Name Textmessage
                      crossAxisAlignment: CrossAxisAlignment.start,//to make the name appear in the left instead of center
                      children: <Widget>[
                        Text(
                          chats[index].sender.name,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: MediaQuery.of(context).size.width*0.60,//used for text
                          // overflow. Manually, width: 250 can also be used but context
                          // is takes the size of the screen and adjusts the text. It is better
                          // to use Mediaquery insted of manual entry
                          child: Text(
                            chats[index].text,
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            //to avoid text coming on to Timestamp and New.Use it along with
                            // width because the overflow property requires some width beyond which
                            // if the text goes then the overflow will act upon it. But then it requires
                            // a width property to be give which can be given by Container. So, wrap
                            //the Text widget with Container
                          ),
                        ),
                      ],//for Name and Textmessage childern ==>
                    ),//for Name and Textmessage
                  ],
                ),

                  Column(//for time
                    children: <Widget>[
                      Container(//to make Timestamp look good, as it was touching the left
                        // screen and also to avoid overflow
                        width: 70,
                        child: Text(
                          chats[index].time,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        width: 45,
                        child: Text(
                            'NEW',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            );//Row==>big outer rectangle of the latest chat
          },
        ),
      ),
    );
  }
}
