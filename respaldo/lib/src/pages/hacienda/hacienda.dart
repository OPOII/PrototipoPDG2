import 'package:latlong/latlong.dart';
import 'package:respaldo/src/pages/suerte/suerte.dart';

class Hacienda {
  String nombre;
  int id;
  List<Suerte> listadoSuertes;
  String ubicacion;
  LatLng ubicacionExacta;
  String imagen;
  int tareasHechas;
  int tareasPorRealizar;
  Hacienda(
      this.nombre,
      this.id,
      this.listadoSuertes,
      this.ubicacion,
      this.ubicacionExacta,
      this.imagen,
      this.tareasHechas,
      this.tareasPorRealizar);
}
