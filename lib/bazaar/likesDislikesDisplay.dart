import 'package:flutter/cupertino.dart';
import 'package:gupshop/widgets/customIconButton.dart';

class LikesDislikesDisplay extends StatelessWidget {
  final int likes;
  final int dislikes;
  final bool likeOrDislike;

  LikesDislikesDisplay({this.likes, this.dislikes, this.likeOrDislike});

  @override
  Widget build(BuildContext context) {
    return Container(///wrapped in a container becuase if later the number of likes or  dislikes  become hummungus then it would not overflow
        padding: EdgeInsets.only(left: 12),
        child: Row(
          children: <Widget>[
            dislikes == null ? CustomIconButton(iconNameInImageFolder: 'thumbsUpNoBackground', onPressed: (){},) : CustomIconButton(iconNameInImageFolder: 'thumbsDownNoBackground', onPressed: (){},),
            dislikes == null ? Text(likes.toString()) : Text(dislikes.toString()),
          ],
        )
    );
  }

  likesDislikesIconButton(){
    if (likeOrDislike == null || likeOrDislike == true){
      return CustomIconButton(iconNameInImageFolder: 'thumbsUpNoBackground', onPressed: (){},);
    } return CustomIconButton(iconNameInImageFolder: 'thumbsDownNoBackground', onPressed: (){},);
  }

}
