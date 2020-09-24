import 'package:gupshop/dataGathering/myTrace.dart';
import 'package:gupshop/responsive/textConfig.dart';

class GroupChatTrace{

  groupMemberDeleted() async{
    int incrementBy = 1; /// correct ?

    MyTrace trace = new MyTrace(nameSpace: TextConfig.groupMemberDeleted);
    await trace.startTrace();
    await trace.metricIncrement(metricName: TextConfig.groupMemberDeleted,
        incrementBy: incrementBy);
    await trace.stopTrace();
  }
}