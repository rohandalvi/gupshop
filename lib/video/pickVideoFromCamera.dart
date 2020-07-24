import 'package:image_picker/image_picker.dart';

class PickVideoFromCamera{
  pick() async{
    return await ImagePicker.pickVideo(source: ImageSource.camera);
  }
}