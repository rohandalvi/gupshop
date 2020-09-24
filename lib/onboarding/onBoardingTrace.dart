import 'package:gupshop/dataGathering/myTrace.dart';
import 'package:gupshop/responsive/textConfig.dart';

class OnBoardingTrace{

  MyTrace trace = new MyTrace(nameSpace: TextConfig.newUserRegistered);

  createNewUser() async{
    int incrementBy = 1; /// correct ?
    await trace.startTrace();
    await trace.metricIncrement(metricName: TextConfig.newUserRegistered,
        incrementBy: incrementBy);
    await trace.stopTrace();
  }
}