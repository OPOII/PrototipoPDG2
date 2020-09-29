import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:respaldo/src/pages/suerte/suerte.dart';

class SuerteView extends StatelessWidget {
  final Suerte suerte;
  SuerteView({Key key, this.suerte}) : super(key: key);
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
          suerte.haciendaPerteneciente,
          style: TextStyle(color: Colors.green[400]),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              mapaMiniatura(new LatLng(3.3591886, -76.3035153)),
              contenerInfo(suerte),
              boton(context)
            ],
          )
        ],
      ),
    );
  }
}

Container boton(BuildContext context) {
  return Container(
    child: RaisedButton(
      child: Text('Ver tareas'),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute());
        // builder: (context) => ListadoSuerte(listadoSuertes: lista)));
      },
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
    ),
  );
}

Container contenerInfo(Suerte n) {
  return Container(
    width: 400,
    height: 300,
    child: Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CostumRow('Hacienda', n.idSuerte),
            CostumRow('Ubicación', n.area),
            CostumRow('Tareas Hechas', n.tareasRealizadas.toString()),
            CostumRow('Tareas Totales', n.totalTareas.toString()),
            CostumRow('Porcentaje',
                ((n.tareasRealizadas / n.totalTareas) * 100).toStringAsFixed(1))
          ],
        ),
      ],
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

class CostumRow extends StatelessWidget {
  String ladoIzq;
  String ladoDer;
  CostumRow(this.ladoIzq, this.ladoDer);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(ladoIzq, style: TextStyle(fontSize: 16.0)),
        Text(ladoDer, style: TextStyle(fontSize: 16.0))
      ],
    );
  }
}
