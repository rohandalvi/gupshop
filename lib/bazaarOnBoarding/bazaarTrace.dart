import 'package:google_maps_flutter/google_maps_flutter.dart';
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


  categoryTapped() async{
    int incrementBy = 1;
    await trace.startTrace();
    await trace.metricIncrement(metricName: category,
        incrementBy: incrementBy);
    await trace.stopTrace();
  }

  locationAdded(LatLng latLng) async{
    int incrementBy = 1;
    await trace.startTrace();
    await trace.metricIncrement(metricName: latLng.toString(),
        incrementBy: incrementBy);
    await trace.stopTrace();
  }


  positiveRatingAdded(String bazaarwalaNumber) async{
    int incrementBy = 1;
    await trace.startTrace();
    await trace.metricIncrement(metricName: "$category+_+$subCategory+_$bazaarwalaNumber+_like_hit",
        incrementBy: incrementBy);
    await trace.stopTrace();
  }

  negativeRatingAdded(String bazaarwalaNumber) async{
    int incrementBy = 1;
    await trace.startTrace();
    await trace.metricIncrement(metricName: "$category+_+$subCategory+_$bazaarwalaNumber+_dislike_hit",
        incrementBy: incrementBy);
    await trace.stopTrace();
  }

  reviewAdded(String bazaarwalaNumber) async{
    int incrementBy = 1;
    await trace.startTrace();
    await trace.metricIncrement(metricName: "$category+_+$subCategory+_$bazaarwalaNumber+_review_hit",
        incrementBy: incrementBy);
    await trace.stopTrace();
  }

  nameChange(String bazaarwalaNumber) async{
    int incrementBy = 1;
    await trace.startTrace();
    await trace.metricIncrement(metricName: "$category+_+$subCategory+_$bazaarwalaNumber+_nameChanged",
        incrementBy: incrementBy);
    await trace.stopTrace();
  }
}