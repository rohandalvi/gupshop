import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/responsive/iconConfig.dart';
import 'package:gupshop/responsive/paddingConfig.dart';
import 'package:gupshop/widgets/customIcon.dart';


class LikesDislikesDisplay extends StatelessWidget {
  final int likes;
  final int dislikes;
  final bool like;
  final bool dislike;

  LikesDislikesDisplay({this.likes, this.dislikes, this.like, this.dislike});

  @override
  Widget build(BuildContext context) {
    return Container(///wrapped in a container becuase if later the number of likes or  dislikes  become hummungus then it would not overflow
        padding: EdgeInsets.only(left: PaddingConfig.twelve),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: dislikes == null ? CustomIcon(iconName: IconConfig.thumbsUpNoBackground,) : CustomIcon(iconName: IconConfig.thumbsDownNoBackground,),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.loose,
              child: dislikes == null ? Text(likes.toString()) : Text(dislikes.toString()),
            ),

          ],
        )
    );
  }

  likesDislikesIconButton(){
    if ((like == null || like == true) && (dislike == null || dislike == false) ){
      return CustomIcon(iconName: IconConfig.thumbsUpNoBackground,);
    } return CustomIcon(iconName: IconConfig.thumbsDownNoBackground,);
  }

}
