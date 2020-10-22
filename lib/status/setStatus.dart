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


  /// to create a map which is used to display status icon and status name in
  /// onItemFound
  Future<void> getStatusMap() async{
    Map<String, String> statusMapTemp = await StatusMap().getStatusMap();
    setState(() {
      statusMap = statusMapTemp;
    });
    print("statusMap : $statusMap");
  }


  Future<void> getSuggestionList() async{
    List<String> list = await StatusMap().getStatusNameList();
    setState(() {
      suggestionList = list;
    });
  }

  @override
  void initState() {
    print("in _SelectCategoryToShowInProductDetailsPageState");
    getSuggestionList();
    getStatusMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSearch<String>(
      backButton: (){
        Navigator.pop(context);
      },
      hintText: TextConfig.setStatusHintText,
      suggestions: suggestionList == null ? new List() : suggestionList,
      onSearch: searchCategoryList,
      onItemFound: (String status, int index){
        return ListTile(
          leading: CustomIcon(iconName: statusMap[status],).networkIcon(context),
          title: CustomText(text: status),
          ///displaying on the display name
          onTap:(){},
        );
      },
    );
  }// List<String> listOfCategoriesSelected = snapshot.data["categories"].cast<String>()


  Future<List<String>> searchCategoryList(String text) async {
    List<String> list = await StatusMap().getStatusNameList();
    return list.where((l) => l.toLowerCase()
        .contains(text.toLowerCase()) || l.contains(text)).toList();
  }

  onStatusTap(String statusName, String iconName) async{
    String userPhoneNo = await UserDetails().getUserPhoneNoFuture();

    /// 1) push to status collection :
    await Status(userPhoneNo:userPhoneNo).setStatus(statusName, iconName);

    /// 2) pop the screen
    Navigator.pop(context);
  }

}
