import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class HaciendaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: contener(),
          ),
          Positioned(
              child: Container(
            padding: EdgeInsets.only(top: 50, left: 125),
            child: Text('Nombre de la Hacienda 1'),
          )),
          Positioned(
            child: Container(
              padding: EdgeInsets.only(top: 35, left: 10),
              child: ButtonTheme(
                minWidth: 30,
                height: 30,
                child: RaisedButton(
                  color: Colors.green.withOpacity(0.5),
                  child: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushNamed(context, "/Mapas");
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                ),
              ),
            ),
          ),
          Positioned(
            child: Container(
              padding: EdgeInsets.only(top: 90, left: 60),
              height: 340,
              width: 330,
              child: mapaMiniatura(),
            ),
          ),
          Positioned(
            top: 320,
            child: Container(
              child: contenerInfo(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 630, left: 135),
            child: boton(context),
          )
        ],
        overflow: Overflow.visible,
      ),
    );
  }
}

Widget contener() {
  return Scaffold();
}

Container boton(BuildContext context) {
  return Container(
    child: RaisedButton(
      child: Text('Buscar Suerte'),
      onPressed: () {
        Navigator.pushNamed(context, "");
      },
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
    ),
  );
}

Container contenerInfo() {
  return Container(
    //decoration: new BoxDecoration(color: Colors.red),
    width: 400,
    height: 300,
    child: Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Hacienda',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Entorno virtual',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 100),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Ubicación',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Nombre',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 150),
          child: Row(
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Tareas Hechas',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Nombre',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Tareas por Realizar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Nombre',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 250),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Porcentaje',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Nombre',
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Container mapaMiniatura() {
  final centro = LatLng(3.3591886, -76.3035153);
  return Container(
    width: 400,
    height: 300,
    child: FlutterMap(
      options: new MapOptions(center: centro, minZoom: 5),
      layers: [
        new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'])
      ],
    ),
  );
}
