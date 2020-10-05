import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:respaldo/src/pages/suerte/lobbySuerte.dart';
import 'package:respaldo/src/pages/suerte/suerte.dart';
import 'package:respaldo/src/pages/hacienda/hacienda.dart';

class HaciendaView extends StatelessWidget {
  final Hacienda hacienda;
  //No se por que pero es necesario usar lo del key para poder pasar los parametros que necesitamos
  HaciendaView({Key key, this.hacienda}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green[400]),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          hacienda.nombre,
          style: TextStyle(color: Colors.green[400]),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              mapaMiniatura(hacienda.ubicacionExacta),
              contenerInfo(hacienda),
              boton(context, hacienda.listadoSuertes)
            ],
          )
        ],
      ),
    );
  }
}

Container boton(BuildContext context, List<Suerte> lista) {
  return Container(
    child: RaisedButton(
      child: Text('Buscar Suerte'),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListadoSuerte(listadoSuertes: lista)));
      },
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
    ),
  );
}

Container mapaMiniatura(LatLng parametro) {
  final centro = parametro;
  return Container(
    width: 300,
    height: 300,
    child: FlutterMap(
      options: new MapOptions(center: centro, minZoom: 5),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        new MarkerLayerOptions(markers: [
          new Marker(
              width: 30,
              height: 30,
              point: centro,
              builder: (context) => new Container(
                    child: IconButton(
                        color: Colors.blue,
                        icon: Icon(Icons.location_on),
                        onPressed: null),
                  ))
        ])
      ],
    ),
  );
}

Container contenerInfo(Hacienda n) {
  return Container(
    width: 400,
    height: 300,
    child: Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CostumInfo('Hacienda', n.nombre),
            CostumInfo('Ubicación', n.ubicacion),
            CostumInfo('Tareas Hechas', n.tareasHechas.toString()),
            CostumInfo('Tareas Totales', n.tareasPorRealizar.toString()),
            CostumInfo(
                'Porcentaje',
                ((n.tareasHechas / n.tareasPorRealizar) * 100)
                    .toStringAsFixed(1))
          ],
        ),
      ],
    ),
  );
}

class CostumInfo extends StatelessWidget {
  String ladoIzq;
  String ladoDer;
  CostumInfo(this.ladoIzq, this.ladoDer);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          ladoIzq,
          style: TextStyle(fontSize: 16.0),
        ),
        Text(ladoDer, style: TextStyle(fontSize: 16.0))
      ],
    );
  }
}
