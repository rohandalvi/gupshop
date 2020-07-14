import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';
import 'package:gupshop/widgets/threeIconsNumbersRow.dart';

class TrueFakeVotingIcons extends StatelessWidget {
  bool isMe;
  String count1;
  GestureTapCallback onTap1;
  String count2;
  GestureTapCallback onTap2;
  String count3;
  GestureTapCallback onTap3;

  TrueFakeVotingIcons({@required this.isMe, this.onTap1, this.onTap2, this.onTap3});

  @override
  Widget build(BuildContext context) {
    return ThreeIconsNumbersRow(
      isMe: isMe,
      icon1Name: 'warning',
      count1: count1,
      onTap1: onTap1,
      icon2Name: 'like',
      count2: count2,
      onTap2: onTap2,
      icons3Name: 'skullAndBones',
      count3: count3,
      onTap3: onTap3,
    );
  }
}