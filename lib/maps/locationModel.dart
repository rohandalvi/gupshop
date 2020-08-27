
class LocationModel {
  int id;
  String number;
  String direction;
  double lat;
  double long;
  LocationModel({this.id, this.number, this.direction, this.lat, this.long});
  @override
  String toString() {
    return 'LocationModel { nombre: $number, direccion: $direction, lat: $lat, long: $long}';
  }
}