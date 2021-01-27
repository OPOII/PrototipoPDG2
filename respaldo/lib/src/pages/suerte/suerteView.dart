import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:respaldo/src/DatabaseView.dart';

class SuerteView extends StatefulWidget {
  final QueryDocumentSnapshot suerte;
  SuerteView({Key key, this.suerte}) : super(key: key);

  @override
  _SuerteViewState createState() => _SuerteViewState();
}

class _SuerteViewState extends State<SuerteView> {
  ConnectivityResult oldres;
  StreamSubscription connectivityStream;
  bool dialogshown = false;
  // ignore: missing_return
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
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          'Hacienda perteneciente: \n' + widget.suerte['haciendaPerteneciente'],
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          mapaMiniatura(widget.suerte.data()['direccion']),
          SizedBox(
            height: 20,
          ),
          CostumRow(
            text: 'Suerte: ' + widget.suerte['id_suerte'],
            press: () => {},
            icon: Icons.location_on,
          ),
          CostumRow(
            text: 'Ubicacion: ' + widget.suerte['area'].toString(),
            press: () => {},
            icon: Icons.article,
          ),
          CostumRow(
            text: 'Tareas Hechas: ',
            press: () => {},
            icon: Icons.done,
          ),
          CostumRow(
            text: 'Tareas Totales: ',
            press: () => {},
            icon: Icons.note_add,
          ),
          CostumRow(
            text: 'Porcentaje: ' + ((85 / 200) * 100).toStringAsFixed(1),
            press: () => {},
            icon: Icons.bar_chart,
          ),
        ],
      )),
    );
  }
}

Container mapaMiniatura(GeoPoint data) {
  LatLng centro = new LatLng(data.latitude, data.longitude);

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
class CostumRow extends StatelessWidget {
  String text;
  VoidCallback press;
  IconData icon;
  CostumRow({this.text, this.press, this.icon});

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
