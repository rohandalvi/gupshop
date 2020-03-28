import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {

  int selectedIndex=0;
  List<String> list = ['Messages', 'Gifs', 'Transcations'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,//makes the list contents display horizontally
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {//itemBuilder is  a typedef.
            return GestureDetector(//wrapping with  GestureDetector to select items from the list 'list'
              onTap:() {//a variable from GestureDetector constructor of type GestureTapCallBack
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Padding(//to create proper spacing between the words in list
                padding: EdgeInsets.symmetric(//padding is the property in Padding class, which is of type EdgeInsetsGeometry
                  horizontal: 7.0,//spacing between words
                  vertical: 30.0,//alignment wrt to app bar i.e closer to app bar or closer to bottom of the container
                ),
                child: Text(
                    list[index],
                  style: TextStyle( //styling the text inside the list
                    color: index== selectedIndex ? Colors.white:Colors.white60,//if the current index(item in list) in selected then, highlight it
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),//displays in linear form.Eka khali ek, if scroll direction not used
              ),
            );
          },
      ),
    );
  }
}
