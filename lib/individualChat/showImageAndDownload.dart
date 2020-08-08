import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gupshop/image/displayCircularPicture.dart';
import 'package:gupshop/image/downloadImage.dart';
import 'package:gupshop/widgets/customFlushBar.dart';
import 'package:gupshop/widgets/customIconButton.dart';
import 'package:gupshop/widgets/customText.dart';

class ShowImageAndDownload extends StatefulWidget {
  final String imageURL;

  ShowImageAndDownload({this.imageURL});

  @override
  _ShowImageAndDownloadState createState() => _ShowImageAndDownloadState();
}

class _ShowImageAndDownloadState extends State<ShowImageAndDownload> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DisplayCircularPicture().chatPictureFrame(widget.imageURL),
        CustomIconButton(
          onPressed: () async{
            CustomFlushBar(
              customContext: context,
              iconName: 'speaker',
              text: CustomText(text : 'Downloading image...............', fontSize: 13,),
              message: 'Downloading image..........',
            ).showFlushBar();
            var imageId = await DownloadImage(imageURL: widget.imageURL).download();
            if(imageId != null){
              return CustomFlushBar(
                customContext: context,
                iconName: 'speaker',
                text: CustomText(text : 'Image downloaded in your device', fontSize: 13,),
                message: 'Image downloaded in your device',
              ).showFlushBar();
            }
            if(imageId == null){
              return CustomFlushBar(
                customContext: context,
                iconName: 'exclamation',
                text: CustomText(text : 'Could not download image', fontSize: 13,),
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
