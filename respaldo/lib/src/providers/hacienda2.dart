import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:respaldo/src/pages/suerte/suerte.dart';

class Hacienda2 with ChangeNotifier {
  String nombre = "Juan";
  int id;
  List<Suerte> listadoSuertes;
  String ubicacion;
  LatLng ubicacionExacta;
  String imagen;
  int tareasHechas;
  int tareasPorRealizar;
  void notifyListeners() {
    super.notifyListeners();
  }

  get n {
    return nombre;
  }
}
