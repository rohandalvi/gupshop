import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/PushToFirebase/status.dart';
import 'package:gupshop/PushToFirebase/statusMap.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/navigators/navigateToProductDetailPage.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/customIcon.dart';
import 'package:gupshop/widgets/customSearch.dart';
import 'package:gupshop/widgets/customText.dart';

class SetStatus extends StatefulWidget {

  @override
  _SetStatusState createState() => _SetStatusState();
}

class _SetStatusState extends State<SetStatus> {
  Map<String, String> statusMap;
  List<String> suggestionList;


  /// Create a map which is used to display status icon and status name in
  /// onItemFound
  Future<void> getStatusMap() async{
    Map<String, String> statusMapTemp = await StatusMap().getStatusMap();
    setState(() {
      statusMap = statusMapTemp;
    });
  }


  /// extracting suggestionList from firebase
  Future<void> getSuggestionList() async{
    List<String> list = await StatusMap().getStatusNameList();
    setState(() {
      suggestionList = list;
    });
  }

  @override
  void initState() {
    getSuggestionList();
    getStatusMap();
    super.initState();
  }


  /// We are showing the end result of iconName and statusName in ListTile where
  /// iconName is leading and statusName is title.
  ///
  /// We just need to extract the map that is stored in firebase for display,
  /// which is done by getStatusMap()
  @override
  Widget build(BuildContext context) {
    return CustomSearch<String>(
      backButton: (){
        Navigator.pop(context);
      },
      hintText: TextConfig.setStatusHintText,
      suggestions: suggestionList == null ? new List() : suggestionList,
      onSearch: searchCategoryList,
      noResultsText: TextConfig.noResultsText,
      onItemFound: (String status, int index){
        return ListTile(
          leading: CustomIcon(iconName: statusMap[status],).networkIcon(context),/// icon
          title: CustomText(text: status),/// statusName
          onTap:() async{
            String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

            /// 1) push to status collection :
            await Status(userPhoneNo:userPhoneNo).setStatus(status, statusMap[status]);

            /// 2) pop the screen
            Navigator.pop(context);
          },
        );
      },
    );
  }// List<String> listOfCategoriesSelected = snapshot.data["categories"].cast<String>()


  /// extracting the statusNames in a list from firebase using the StatusMap().getStatusNameList()
  /// It does not need icon, apparently the icons are displayed by the by the
  /// ListTile, we are not explicitly giving the icons anywhere other than
  /// the listTile
  Future<List<String>> searchCategoryList(String text) async {
    List<String> list = await StatusMap().getStatusNameList();
    return list.where((l) => l.toLowerCase()
        .contains(text.toLowerCase()) || l.contains(text)).toList();
  }

}
