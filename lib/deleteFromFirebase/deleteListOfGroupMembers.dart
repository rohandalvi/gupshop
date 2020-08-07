import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/group/createGroup.dart';

class DeleteListOfGroup extends StatelessWidget {
  List<dynamic> listOfGroupMemberNumbers;


  DeleteListOfGroup({@required this.listOfGroupMemberNumbers});
  @override
  Widget build(BuildContext context) {
    return CreateGroup(
      onSearch: searchList,
//      onItemFound: (DocumentSnapshot doc, int index){
//        return Container(
//          child: CheckboxListTile(
////            secondary: map[doc.data["nameList"][0]] == true ?IconButton(
////                icon: SvgPicture.asset('images/done.svg',)
////            ) : null,
//            controlAffinity:ListTileControlAffinity.leading ,
//            title: widget.title==null ? (CustomText(text: doc.data["nameList"][0]) == null ? CustomText(text: 'loading',):CustomText(text: doc.data["nameList"][0])) : widget.title,
//            activeColor: primaryColor,
//            value: widget.value==null ? (map[doc.data["phone"][0]] == null ? false : map[doc.data["phone"][0]]) : widget.value,/// if value of a key in map(a phonenumber) is false or true
//            //list[index],/// at first all the values would be false
//            onChanged: widget.onChanged==null ? (bool val){
//              setState(() {
//                map[doc.data["phone"][0]] = val; /// setting the new value as selected by user
//              });
//            } : widget.onChanged,
//          ),
//        );
//        //title: CustomText(text: doc.data["nameList"][0]),
//      },
    );
  }

  searchList(String text){
    return listOfGroupMemberNumbers.where((l) =>
    l.toLowerCase()
        .contains(text.toLowerCase()) || l.documentID.contains(text)).toList();
  }
}
