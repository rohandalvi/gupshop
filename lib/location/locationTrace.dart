import 'package:gupshop/dataGathering/myTrace.dart';
import 'package:gupshop/responsive/textConfig.dart';

class LocationTrace{

  addressUpdatedByUser() async{
    int incrementBy = 1; /// correct ?

    MyTrace trace = new MyTrace(nameSpace: TextConfig.userHomeAddress);
    await trace.startTrace();
    await trace.metricIncrement(metricName: TextConfig.userHomeAddressUpdated,
        incrementBy: incrementBy);
    await trace.stopTrace();
  }
}