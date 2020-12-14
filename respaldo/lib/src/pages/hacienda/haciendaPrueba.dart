import 'package:cloud_firestore/cloud_firestore.dart';

class HaciendaPrueba {
  String haciendaname;
  num area;
  num idhacienda;
  num idingenio;
  String incharge;
  GeoPoint location;
  String claveHacienda;
  String imagen;
  HaciendaPrueba(
      {this.haciendaname,
      this.area,
      this.idhacienda,
      this.idingenio,
      this.incharge,
      this.location,
      this.claveHacienda,
      this.imagen});
  factory HaciendaPrueba.fromJson(Map<String, dynamic> json) {
    return HaciendaPrueba(
        haciendaname: json['hacienda_name'],
        area: json['area'],
        idhacienda: json['id_hacienda'],
        idingenio: json['id_ingenio'],
        incharge: json['in_charge'],
        location: json['location'],
        claveHacienda: json['clave_hacienda'],
        imagen: json['imagen']);
  }
  Map<String, dynamic> toMap() {
    return {
      'hacienda_name': haciendaname,
      'area': area,
      'id_hacienda': idhacienda,
      'id_ingenio': idingenio,
      'in_charge': incharge,
      'location': location,
      'clave_hacienda': claveHacienda,
      'imagen': imagen
    };
  }
}
