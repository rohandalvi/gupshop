import 'package:image_picker/image_picker.dart';

class PickImageFromCamera{
  pick() async{
    return await ImagePicker.pickImage(source: ImageSource.camera,imageQuality: 50);
  }
}