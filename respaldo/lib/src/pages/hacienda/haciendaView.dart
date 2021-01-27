import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:respaldo/src/DatabaseView.dart';
import 'package:respaldo/src/pages/suerte/lobbySuerte.dart';

class HaciendaView extends StatefulWidget {
  final QueryDocumentSnapshot hacienda;
  //No se por que pero es necesario usar lo del key para poder pasar los parametros que necesitamos
  HaciendaView({Key key, this.hacienda}) : super(key: key);

  @override
  _HaciendaViewState createState() => _HaciendaViewState();
}

class _HaciendaViewState extends State<HaciendaView> {
  ConnectivityResult oldres;
  StreamSubscription connectivityStream;
  bool dialogshown = false;

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      }
    } on SocketException catch (_) {
      return Future.value(false);
    }
  }

  @override
  void initState() {
    super.initState();
    connectivityStream =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult resu) {
      if (resu == ConnectivityResult.none) {
        dialogshown = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          child: AlertDialog(
            title: Text('Error'),
            content: Text('No Data Connection Available'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DatabaseInfo())),
                  //SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                },
                child: Text('Ir al modo OffLine'),
              )
            ],
          ),
        );
      } else if (oldres == ConnectivityResult.none) {
        checkInternet().then((result) {
          if (result == true) {
            if (dialogshown == true) {
              dialogshown = false;
              Navigator.pop(context);
            }
          }
        });
      }
      oldres = resu;
    });
  }

  @override
  void dispose() {
    super.dispose();
    connectivityStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.hacienda.id);
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
          mapaMiniatura(widget.hacienda.data()['location']),
          SizedBox(
            height: 20,
          ),
          CostumInfo(
              text: '' + widget.hacienda.data()['hacienda_name'],
              press: () => {},
              icon: Icons.location_on),
          CostumInfo(
            text: 'Identificación ' +
                widget.hacienda.data()['id_hacienda'].toString(),
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
          boton(context, widget.hacienda)
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
