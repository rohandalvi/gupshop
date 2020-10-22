import 'package:gupshop/dataGathering/myTrace.dart';
import 'package:gupshop/responsive/textConfig.dart';

class StatusTrace{
  MyTrace trace;
  String statusName;

  StatusTrace({this.statusName}){
    trace = new MyTrace(nameSpace: '$statusName+trace');
  }


  statusHit() async{
    int incrementBy = 1; /// correct ?
    await trace.startTrace();
    await trace.metricIncrement(metricName: '$statusName+hit',
        incrementBy: incrementBy);
    await trace.stopTrace();
  }
}