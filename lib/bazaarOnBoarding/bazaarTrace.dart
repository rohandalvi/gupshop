import 'package:gupshop/dataGathering/myTrace.dart';
import 'package:gupshop/responsive/textConfig.dart';

class BazaarTrace{
  String category;
  String subCategory;

  MyTrace trace;

  BazaarTrace({this.category, this.subCategory}){
    trace = new MyTrace(nameSpace: category+TextConfig.bazaarCategory);
  }

  subCategoryAdded() async{
    int incrementBy = 1; /// correct ?
    await trace.startTrace();
    await trace.metricIncrement(metricName: subCategory+TextConfig.bazaarSubCategory,
        incrementBy: incrementBy);
    await trace.stopTrace();
  }

}