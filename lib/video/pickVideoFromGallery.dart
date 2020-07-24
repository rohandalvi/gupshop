import 'package:image_picker/image_picker.dart';

class PickVideoFromGallery{
  pick() async{
    return await ImagePicker.pickVideo(source: ImageSource.gallery);
  }
}