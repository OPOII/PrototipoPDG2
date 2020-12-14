import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class SuerteView extends StatelessWidget {
  final QueryDocumentSnapshot suerte;
  SuerteView({Key key, this.suerte}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          'Hacienda perteneciente: \n' + suerte['haciendaPerteneciente'],
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              mapaMiniatura(suerte.data()['direccion']),
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
        Navigator.push(
            context,
            // ignore: missing_return
            MaterialPageRoute(builder: (BuildContext context) {}));
        // builder: (context) => ListadoSuerte(listadoSuertes: lista)));
      },
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
    ),
  );
}

Container contenerInfo(QueryDocumentSnapshot n) {
  return Container(
    width: 400,
    height: 300,
    child: Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CostumRow('Suerte', n['id_suerte']),
            CostumRow('Ubicación', n['area'].toString()),
            CostumRow('Tareas Hechas', '85'),
            CostumRow('Tareas Totales', '200'),
            CostumRow('Porcentaje', ((85 / 200) * 100).toStringAsFixed(1))
          ],
        ),
      ],
    ),
  );
}

Container mapaMiniatura(GeoPoint data) {
  LatLng centro = new LatLng(data.latitude, data.longitude);

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

// ignore: must_be_immutable
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
