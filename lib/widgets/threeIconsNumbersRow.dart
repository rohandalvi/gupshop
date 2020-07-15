import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class ThreeIconsNumbersRow extends StatelessWidget {
  String icon1Name;
  String count1;
  GestureTapCallback onTap1;
  String icon2Name;
  String count2;
  GestureTapCallback onTap2;
  String icons3Name;
  String count3;
  GestureTapCallback onTap3;
  bool isMe;

  ThreeIconsNumbersRow({this.icon1Name, this.icon2Name, this.icons3Name, this.onTap1, this.onTap2, this.onTap3, this.count1, this.count2, this.count3, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      /// for alignment to right or left depending on who has sent it, we are using mainAxisAlignment.
      /// Normally we would use 'alignment: isMe? Alignment.centerRight: Alignment.centerLeft,' of the container
      /// but it is not working  here for some reason
      mainAxisAlignment: isMe?MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[
              GestureDetector(
                child: CustomIconButton(
                  iconNameInImageFolder: icon1Name,
                ),
                onTap: onTap1,
              ),
              CustomText(text: count1,),
              /// toDo - with large numbers, overflow would occur
//              CustomText(text: '9',),
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              GestureDetector(
                child: CustomIconButton(
                  iconNameInImageFolder: icon2Name,
                ),
                onTap: onTap2,
              ),
              CustomText(text: count2,),
//              CustomText(text: '10',)
            ],
          ),
        ),
        Container(
          child: Row(
            children: <Widget>[
              GestureDetector(
                child: CustomIconButton(
                  iconNameInImageFolder: icons3Name,
                ),
                //onTap: onTap3,
              ),
              CustomText(text: count3,)
//              CustomText(text: '7',)
            ],
          ),
        ),
      ],
    );
  }
}