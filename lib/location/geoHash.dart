import 'package:gupshop/responsive/intConfig.dart';
import 'package:proximity_hash/proximity_hash.dart';

class GeoHash{

  int precision;

  GeoHash({int precision = IntConfig.precision}){
    this.precision = precision ?? IntConfig.precision;
  }

  getListOfGeoHash({double latitude, double longitude, double radius,}){
    print("latitude in getListOfGeoHash : $latitude");
    print("longitude in getListOfGeoHash : $longitude");
    List<String> list = createGeohashes(latitude, longitude, radius, precision);
    return list;
  }

}