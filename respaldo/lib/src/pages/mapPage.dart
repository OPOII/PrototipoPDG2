import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'navigator_drawer.dart';

//Clase donde voy a dibujar el mapa con los botones de las
//tareas importantes para realizar y el boton para deslizar la barra a un lado
class Map extends StatelessWidget {
  //Constante de la localización de cenicaña
  final centro = LatLng(3.3591886, -76.3035153);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //El cuerpo sera un stack para poder widgets encima de el sin tener que repintarlo
      body: Stack(
        children: <Widget>[
          //Primer widget posicionado y guardado con un container, que es el del mapa
          Positioned(
            child: Container(
              child: mapa(),
            ),
          ),
          //Pongo encima del widget los botones
          Positioned(
            top: 750,
            child: Container(
              child: botonesFlotantes(),
            ),
          ),
        ],
      ),
      drawer: NavitagorDrawer(),
      // floatingActionButton: botonesFlotantes(),
    );
  }

  Row botonesFlotantes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Botón de agua
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: RaisedButton(
            child: Text('Fertilización'),
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: RaisedButton(
            child: Text('Maduración'),
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: RaisedButton(
            child: Text('Riego'),
            onPressed: () {},
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
          ),
        ),
        //Padding(
        //  padding: const EdgeInsets.all(1.0),
        //child: RaisedButton(
        //child: Text('Productivity'),
        //onPressed: () {},
        //shape: RoundedRectangleBorder(
        //      borderRadius: new BorderRadius.circular(20.0)),
        //),
        //),
        //Botón de ver hectareas
      ],
    );
  }
}

class Copia extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Scaffold(
        appBar: AppBar(
          title: Text('hi'),
        ),
        drawer: barraDeslizante(),
      ),
    );
  }

  Drawer barraDeslizante() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Hili'),
            leading: Icon(Icons.whatshot),
          ),
          ListTile(
            title: Text('Bojou'),
            leading: Icon(Icons.free_breakfast),
          )
        ],
      ),
    );
  }
}

Widget mapa() {
  final centro = LatLng(3.3591886, -76.3035153);
  return Scaffold(
    body: Stack(
      children: <Widget>[
        Container(
          child: FlutterMap(
            options: new MapOptions(center: centro, minZoom: 5),
            layers: [
              new TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'])
            ],
          ),
        ),
        appBarDeslizable()
      ],
    ),
    drawer: NavitagorDrawer(),
  );
}

Container appBarDeslizable() {
  return Container(
    width: 100,
    height: 70,
    child: AppBar(
      iconTheme: IconThemeData(color: Colors.blue),
      title: Text(''),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    ),
  );
}
