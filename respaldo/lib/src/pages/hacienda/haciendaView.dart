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
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          mapaMiniatura(hacienda.data()['location']),
          SizedBox(
            height: 20,
          ),
          CostumInfo(
              text: '' + hacienda.data()['hacienda_name'],
              press: () => {},
              icon: Icons.location_on),
          CostumInfo(
            text: 'Identificación ' + hacienda.data()['id_hacienda'].toString(),
            press: () => {},
            icon: Icons.article,
          ),
          CostumInfo(
            text: "Tareas Hechas 55",
            press: () => {},
            icon: Icons.done,
          ),
          CostumInfo(
            text: 'Tareas Totales 88',
            press: () => {},
            icon: Icons.note_add,
          ),
          CostumInfo(
            text: 'Porcentaje: ' + ((55 / 88) * 100).toStringAsFixed(1),
            press: () => {},
            icon: Icons.bar_chart,
          ),
          // contenerInfo(hacienda),
          boton(context, hacienda)
        ],
      )),
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
    width: 400,
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
class CostumInfo extends StatelessWidget {
  String text;
  VoidCallback press;
  IconData icon;
  CostumInfo({this.text, this.press, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Color(0xFFF5F6F9),
        onPressed: press,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            SizedBox(width: 20),
            Expanded(
                child: Text(
              text,
              textAlign: TextAlign.justify,
            )),
          ],
        ),
      ),
    );
  }
}
