import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:respaldo/authentication_service.dart';
import 'package:respaldo/src/pages/Ingenio.dart';
import 'package:respaldo/src/pages/tablaDatos/tablaDatos.dart';
import 'package:respaldo/src/pages/tarea/tareaView.dart';
import 'package:respaldo/src/pages/user/usuario.dart';

import 'Calendarrio/CalendarioView.dart';
import 'admin area/adminArea.dart';
import 'hacienda/hacienda.dart';
import 'hacienda/haciendaView.dart';

class Lobby extends StatefulWidget {
  @override
  _LobbyState createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Ingenio pruebas = new Ingenio();
  AuthenticationService _authenticationService = AuthenticationService();
  List<Hacienda> listado = new List<Hacienda>();
  @override
  Widget build(BuildContext context) {
    if (_authenticationService.currentUser == null) {
      Navigator.of(context).pop();
    } else {
      pruebas.cargarSuertes();
      pruebas.cargarHacienda();
      listado = pruebas.listado;
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Ingenio')
              .doc('1')
              .collection('users')
              .doc(_authenticationService.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Text('Loading');
              default:
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: personalizada(context, listado),
                  body: Stack(
                    children: <Widget>[
                      Column(
                        children: [
                          barraInfo(pruebas),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: haciendaListado(context, listado),
                          ),
                        ],
                      )
                    ],
                  ),
                  drawer: Container(
                      width: 200,
                      child: menuDeslizante(context, snapshot.data['charge'],
                          snapshot.data['name'], snapshot.data['urlfoto'])),
                );
            }
          });
    }
  }
}

Drawer menuDeslizante(context, data, data1, data2) {
  print(data);
  final usuario = Provider.of<Usuario>(context);
  final AuthenticationService _auth = AuthenticationService();
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
                        child: Image.network(
                          data2.toString(),
                          width: 80,
                          height: 80,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      data1.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  )
                ],
              ),
            )),
        CustomListTile(
            Icons.assessment,
            'Resumen',
            () => {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => tabla()))
                }),
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
        CustomListTile(
          Icons.calendar_today,
          'Calendario',
          () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CalendarioView()))
          },
        ),
        CustomListTile(Icons.settings, 'Configuración', () => {}),
        if (data != null && data == 'admin')
          CustomListTile(
              Icons.assignment_ind,
              'Area de admin',
              () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AdminArea()))
                  }),
        CustomListTile(Icons.power_settings_new, 'Salir', () async {
          await FirebaseAuth.instance.signOut();
          Navigator.of(context).pop();
        }),
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

Widget personalizada(BuildContext context, List<Hacienda> haciendas) {
  Icon usIcon = Icon(Icons.search);
  return AppBar(
    iconTheme: IconThemeData(color: Colors.white),
    centerTitle: true,
    title: Text(
      'Tus haciendas',
      style: TextStyle(color: Colors.white),
    ),
    actions: <Widget>[
      IconButton(
          tooltip: 'search',
          icon: usIcon,
          onPressed: () {
            showSearch(
                context: context, delegate: HaciendaSearch(listado: haciendas));
          })
    ],
    backgroundColor: Colors.green,
    elevation: 0.0,
  );
}

Widget haciendaListado(BuildContext context, List<Hacienda> listadoHacienda) {
  return SizedBox(
    height: 500,
    child: Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: EdgeInsets.only(right: 15.0, left: 10),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HaciendaView(
                                  hacienda: listadoHacienda[index])));
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: new Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Image.asset(
                                'assets/haciendas/${listadoHacienda[index].imagen}'),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Ingenio:'),
                              Text(listadoHacienda[index].nombre)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('ID Ingenio:'),
                              Text(listadoHacienda[index].id.toString())
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              })),
    ),
  );
}

Widget barraInfo(Ingenio ingenio) {
  int totalTareas = ingenio.totalTareas(ingenio.listado);
  int totalTareasRealizadas = ingenio.totalTareasHechas(ingenio.listado);
  double porcentaje = (totalTareasRealizadas / totalTareas) * 100;
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
    ),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Información de las haciendas',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total Tareas'),
                Text(
                  totalTareas.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tareas Realizadas'),
                Text(
                  totalTareasRealizadas.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 55),
              child: Text(
                'Porcentaje de progreso',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 55.0),
              child: Container(
                height: 10,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearPercentIndicator(
                    progressColor: ingenio.progreso(porcentaje),
                    animation: true,
                    animationDuration: 3000,
                    lineHeight: 20.0,
                    percent: porcentaje / 100,
                    backgroundColor: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                porcentaje.toStringAsFixed(1) + '%',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        Text('Estado'),
        Text(ingenio.estado(porcentaje))
      ],
    ),
  );
}

class HaciendaSearch extends SearchDelegate<Hacienda> {
  List<Hacienda> listado;
  HaciendaSearch({this.listado});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final myList = query.isEmpty
        ? listado
        : listado.where((p) => p.id.toString().startsWith(query)).toList();
    return myList.isEmpty
        ? Text(
            'No results found...',
            style: TextStyle(fontSize: 20),
          )
        : ListView.builder(
            itemCount: myList
                .length, //Aqui esta el problema, si lo pongo listado.length.compareTo(0) entonces solo me deja ver el primer elemento => update, el error era que le estaba pasando el "listado" en vez de "myList"
            itemBuilder: (context, index) {
              final Hacienda nuevoListado = myList[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HaciendaView(hacienda: listado[index])));
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      nuevoListado.nombre,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text('ID hacienda: ' + nuevoListado.id.toString(),
                        style: TextStyle(color: Colors.grey)),
                    Divider()
                  ],
                ),
                leading: CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/haciendas/${listado[index].imagen}'),
                ),
              );
            });
  }
}
