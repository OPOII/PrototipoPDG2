import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:respaldo/src/pages/Ingenio.dart';
import 'package:respaldo/src/pages/tarea/tareaView.dart';

import 'hacienda/hacienda.dart';

class Map extends StatelessWidget {
  Ingenio pruebas = new Ingenio();
  @override
  Widget build(BuildContext context) {
    pruebas.cargarSuertes();
    pruebas.cargarHacienda();
    return new Scaffold(
      appBar: personalizada(context),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 400, child: grid(context, pruebas.listado))
            ],
          )
        ],
      ),
      drawer: Container(width: 200, child: barraDeslizante(context)),
    );
  }

  //Control shift + R para hacer WRAP e including
  Row botonesFlotantes(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
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
        CustomListTile(
          Icons.insert_drive_file,
          'Info Excel',
          () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TareaView(title: 'Prueba')))
          },
        ),
        CustomListTile(Icons.search, 'Buscar Hacienda',
            () => {Navigator.pushNamed(context, '/ListadoHaciendas')}),
        CustomListTile(Icons.settings, 'Configuración', () => {}),
      ],
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

Widget personalizada(BuildContext context) {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.green),
    centerTitle: true,
    title: Text(
      'Tus haciendas',
      style: TextStyle(color: Colors.green[400]),
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
  );
}

Widget grid(BuildContext context, List<Hacienda> listadoHacienda) {
  return Scaffold(
    backgroundColor: Color(0xFFFCFAF8),
    body: ListView(
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
        Container(
          padding: EdgeInsets.only(right: 15.0),
          width: MediaQuery.of(context).size.width - 30.0,
          height: MediaQuery.of(context).size.height - 50.0,
          child: GridView.builder(
            itemCount: listadoHacienda.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 4.0),
                  child: InkWell(
                    onTap: () {
                      print('Card numero: ' + index.toString());
                    },
                    child: Card(
                      elevation: 10.0,
                      child: new Column(
                        children: <Widget>[
                          Image.asset(
                              'assets/haciendas/${listadoHacienda[index].imagen}'),
                          SizedBox(
                            height: 5.0,
                          ),
                          Column(
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Row(
                                  children: [
                                    Text('Ingenio:'),
                                    Text(listadoHacienda[index].nombre)
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                child: Row(
                                  children: [
                                    Text('IDIngenio:'),
                                    Text(listadoHacienda[index].id.toString())
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
            },
          ),
        )
      ],
    ),
  );
}
