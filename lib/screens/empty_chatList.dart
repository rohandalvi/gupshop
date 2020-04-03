import 'package:flutter/material.dart';

class EmptyChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: RichText(
            text: TextSpan(
              text: "Go to Contacts tab to find who is using ",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 17.0,
              ),
              children: [
                TextSpan(
                  text: "GupShop",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  )
                )
              ]
            ),
          ),
      ),
    );
  }
}
