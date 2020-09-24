import 'package:gupshop/dataGathering/myTrace.dart';
import 'package:gupshop/responsive/textConfig.dart';

class ChatListTrace{
  MyTrace trace;

  ChatListTrace(){
    trace = new MyTrace(nameSpace: TextConfig.cachedAvatar);
  }


  cachedAvatarHit() async{
    int incrementBy = 1; /// correct ?
    await trace.startTrace();
    await trace.metricIncrement(metricName: TextConfig.cachedAvatarHit,
        incrementBy: incrementBy);
    await trace.stopTrace();
  }


  nonCachedAvatarHit() async{
    int incrementBy = 1; /// correct ?
    await trace.startTrace();
    await trace.metricIncrement(metricName: TextConfig.nonCachedAvatarHit,
        incrementBy: incrementBy);
    await trace.stopTrace();
  }

}