import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

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
              child: mapa(context),
            ),
          ),
          //Pongo encima del widget los botones
          Positioned(
            top: 750,
            child: Container(
              child: botonesFlotantes(context),
            ),
          ),
        ],
      ),
      // drawer: NavitagorDrawer(),
      // floatingActionButton: botonesFlotantes(),
    );
  }

  //Control shift + R para hacer WRAP e including
  Row botonesFlotantes(BuildContext context) {
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
            onPressed: () {
              Navigator.pushNamed(context, "/BalanceHidrico");
            },
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

Drawer barraDeslizante(context) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
            decoration: BoxDecoration(color: Colors.white),
            //gradient: LinearGradient(
            //  colors: <Color>[Colors.green, Colors.green[800]])),
            child: Container(
              child: Column(
                children: <Widget>[
                  Material(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/imgs/perfil.jpg',
                          width: 80,
                          height: 80,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Nombre de la persona',
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  )
                ],
              ),
            )),
        CustomListTile(Icons.assessment, 'Resumen', () => {}),
        CustomListTile(Icons.insert_drive_file, 'Info Excel', () => {}),
        CustomListTile(Icons.search, 'Buscar Hacienda',
            () => {Navigator.pushNamed(context, '/ListadoHaciendas')}),
        CustomListTile(Icons.settings, 'Configuración', () => {}),
      ],
    ),
  );
}

Widget mapa(context) {
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
    // drawer: NavitagorDrawer(),
    drawer: Container(width: 200, child: barraDeslizante(context)),
  );
}

Container appBarDeslizable() {
  return Container(
    width: 100,
    height: 80,
    child: AppBar(
      iconTheme: IconThemeData(color: Colors.blue),
      title: Text(''),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    ),
  );
}

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;
  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: InkWell(
        splashColor: Colors.blue[100],
        onTap: onTap,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}
