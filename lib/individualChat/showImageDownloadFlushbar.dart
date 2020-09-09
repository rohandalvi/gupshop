import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/displayPicture.dart';
import 'package:gupshop/image/downloadImage.dart';
import 'package:gupshop/responsive/textConfig.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class ShowImageDownloadFlushbar extends StatefulWidget {
  final String imageURL;

  ShowImageDownloadFlushbar({this.imageURL});

  @override
  _ShowImageDownloadFlushbarState createState() => _ShowImageDownloadFlushbarState();
}

class _ShowImageDownloadFlushbarState extends State<ShowImageDownloadFlushbar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DisplayPicture(imageURL: widget.imageURL,).chatPictureFrame( context),
        CustomIconButton(
          onPressed: () async{
            CustomFlushBar(
              customContext: context,
              iconName: 'speaker',
              text: CustomText(text : 'Downloading image...............', fontSize: TextConfig.fontSizeTwelve,),
              message: 'Downloading image..........',
            ).showFlushBar();
            var imageId = await DownloadImage(imageURL: widget.imageURL).download();
            if(imageId != null){
              return CustomFlushBar(
                customContext: context,
                iconName: 'speaker',
                text: CustomText(text : 'Image downloaded in your device', fontSize: TextConfig.fontSizeTwelve,),
                message: 'Image downloaded in your device',
              ).showFlushBar();
            }
            if(imageId == null){
              return CustomFlushBar(
                customContext: context,
                iconName: 'exclamation',
                text: CustomText(text : 'Could not download image', fontSize: TextConfig.fontSizeTwelve,),
                message: 'Could not download image',
              ).showFlushBar();
            }
          },
          iconNameInImageFolder: 'download',
        ),
      ],
    );

  }
}
