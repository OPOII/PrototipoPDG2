import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:respaldo/src/pages/hacienda/hacienda.dart';
import 'package:respaldo/src/pages/suerte/lobbySuerte.dart';
import 'package:respaldo/src/pages/suerte/suerte.dart';

class HaciendaView extends StatelessWidget {
  final Hacienda hacienda;
  //No se por que pero es necesario usar lo del key para poder pasar los parametros que necesitamos
  HaciendaView({Key key, this.hacienda}) : super(key: key);

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
            child: Text(hacienda.nombre),
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
                    Navigator.pushNamed(context, "/ListadoHaciendas");
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
              child: mapaMiniatura(hacienda.ubicacionExacta),
            ),
          ),
          Positioned(
            top: 320,
            child: Container(
              child: contenerInfo(hacienda),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 630, left: 135),
            child: boton(context, hacienda.listadoSuertes),
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

Container contenerInfo(Hacienda n) {
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
                n.nombre,
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
                n.ubicacion,
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
                n.tareasHechas.toString(),
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
                n.tareasPorRealizar.toString(),
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
                ((n.tareasHechas / n.tareasPorRealizar) * 100)
                        .toStringAsFixed(1) +
                    "%",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Container mapaMiniatura(LatLng parametro) {
  final centro = parametro;

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
