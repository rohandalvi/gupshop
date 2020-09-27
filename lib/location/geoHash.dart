import 'package:gupshop/responsive/intConfig.dart';
import 'package:proximity_hash/proximity_hash.dart';

class GeoHash{

  int precision;

  GeoHash({int precision = IntConfig.precision}){
    this.precision = precision ?? IntConfig.precision;
  }

  getListOfGeoHash({double latitude, double longitude, double radius,}){
    List<String> list = createGeohashes(latitude, longitude, radius, precision);
    return list;
  }

}