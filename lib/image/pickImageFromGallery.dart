import 'package:image_picker/image_picker.dart';

class PickImageFromGallery{
  pick() async{
    return await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50);
  }
}