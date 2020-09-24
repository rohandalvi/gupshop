import 'package:gupshop/dataGathering/myTrace.dart';
import 'package:gupshop/modules/userDetails.dart';
import 'package:gupshop/responsive/textConfig.dart';

class ImageTrace{
  String friendNumber;

  MyTrace trace;

  ImageTrace({this.friendNumber}){
    trace = new MyTrace(nameSpace: TextConfig.profilePictureView);
  }

  profilePictureView() async{
    String myNumber = await UserDetails().getUserPhoneNoFuture();

    if(friendNumber == myNumber){
      return friendProfilePictureView();
    }else return myProfilePictureView();
  }

  friendProfilePictureView() async{
    int incrementBy = 1; /// correct ?
    await trace.startTrace();
    await trace.metricIncrement(metricName: friendNumber+TextConfig.profilePictureView,
        incrementBy: incrementBy);
    await trace.stopTrace();
  }


  myProfilePictureView() async{
    int incrementBy = 1; /// correct ?
    await trace.startTrace();
    await trace.metricIncrement(metricName: TextConfig.myProfilePictureView,
        incrementBy: incrementBy);
    await trace.stopTrace();
  }

}