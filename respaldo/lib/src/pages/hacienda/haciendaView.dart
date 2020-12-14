import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:respaldo/src/pages/suerte/lobbySuerte.dart';

class HaciendaView extends StatelessWidget {
  final QueryDocumentSnapshot hacienda;
  //No se por que pero es necesario usar lo del key para poder pasar los parametros que necesitamos
  HaciendaView({Key key, this.hacienda}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(hacienda.id);
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text('Información Hacienda',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              mapaMiniatura(hacienda.data()['location']),
              contenerInfo(hacienda),
              boton(context, hacienda)
            ],
          )
        ],
      ),
    );
  }
}

Container boton(BuildContext context, QueryDocumentSnapshot hacienda) {
  return Container(
    child: RaisedButton(
      child: Text('Buscar Suerte'),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ListadoSuerte(listadoSuertes: hacienda)));
      },
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
    ),
  );
}

Container mapaMiniatura(GeoPoint parametro) {
  LatLng centro = new LatLng(parametro.latitude, parametro.longitude);
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

Container contenerInfo(QueryDocumentSnapshot hacienda) {
  return Container(
    width: 400,
    height: 300,
    child: Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CostumInfo('Hacienda', hacienda.data()['hacienda_name']),
            CostumInfo(
                'Identificación', hacienda.data()['id_hacienda'].toString()),
            CostumInfo('Tareas Hechas', "55"),
            CostumInfo('Tareas Totales', "88"),
            CostumInfo('Porcentaje', ((55 / 88) * 100).toStringAsFixed(1))
          ],
        ),
      ],
    ),
  );
}

// ignore: must_be_immutable
class CostumInfo extends StatelessWidget {
  String ladoIzq;
  String ladoDer;
  CostumInfo(this.ladoIzq, this.ladoDer);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Text(
            ladoIzq,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        Text(ladoDer, style: TextStyle(fontSize: 16.0))
      ],
    );
  }
}
