import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:respaldo/authentication_service.dart';
import 'package:respaldo/src/pages/Ingenio.dart';
import 'package:respaldo/src/pages/activity/activityLobby.dart';
import 'package:respaldo/src/pages/hacienda/haciendaPrueba.dart';
import 'package:respaldo/src/pages/loading.dart';
import 'package:respaldo/src/pages/loginPage.dart';
import 'package:respaldo/src/pages/tablaDatos/tablaDatos.dart';
import 'package:respaldo/src/pages/user/userView.dart';
import 'package:respaldo/src/services/crud.dart';
import 'Calendarrio/CalendarioView.dart';
import 'admin area/adminArea.dart';
import 'hacienda/hacienda.dart';
import 'hacienda/haciendaView.dart';

class Lobby extends StatefulWidget {
  @override
  _LobbyState createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  Ingenio pruebas = new Ingenio();
  AuthenticationService _authenticationService = AuthenticationService();
  List haciendasNuevo = [];
  List<Hacienda> listado = new List<Hacienda>();
  List idHaciendas = [];
  List usuario;
  List<HaciendaPrueba> listadoHacienda = new List<HaciendaPrueba>();
  CrudConsultas consultas = new CrudConsultas();
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
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                },
                child: Text('Exit'),
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

    guardarToken();
    probar();
    haciendasOrganizadas();
  }

  @override
  void dispose() {
    super.dispose();
    connectivityStream.cancel();
  }

  haciendasOrganizadas() async {
    dynamic resultado = await consultas.obtenerListaHaciendas();
  }

  probar() async {
    dynamic resultado = await consultas
        .getEmpleadoActual(_authenticationService.currentUser.uid);
    setState(() {
      usuario = resultado;
    });
  }

  obtenerHaciendas() async {
    dynamic resultado = await consultas.obtenerListadoHaciendas();
    setState(() {
      haciendasNuevo = resultado;
    });
  }

  guardarToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    await firebaseMessaging.getToken().then((value) {
      FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('users')
          .doc(_authenticationService.currentUser.uid)
          .update({'Token_ID': value});
    });
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    if (_authenticationService.currentUser == null) {
      Navigator.of(context).pop();
    } else {
      pruebas.cargarSuertes();
      pruebas.cargarHacienda();
      pruebas.cargarTodo();
      return FutureBuilder<dynamic>(
        future: consultas.obtenerListaHaciendas(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          } else {
            return Scaffold(
              appBar: iconoBuscarHaciendas(context, snapshot.data),
              body: SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        barraInfo(pruebas),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: haciendaListado(context, snapshot),
                        )
                      ],
                    )
                  ],
                ),
              ),
              drawer: Container(
                  width: 200,
                  child: usuario != null
                      ? menuDeslizante(context, usuario)
                      : Loading()),
            );
          }
        },
      );
    }
  }
}

Drawer menuDeslizante(context, List usuario) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 115,
                width: 120,
                child: Stack(
                  fit: StackFit.expand,
                  overflow: Overflow.visible,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(usuario[0]['urlfoto']),
                    ),
                  ],
                ),
              ),
              Text(usuario[0]['name'],
                  style: TextStyle(color: Colors.black, fontSize: 15.0)),
            ],
          ),
        ),
        CustomListTile(
            Icons.assessment,
            'Resumen',
            () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Tabla()),
                  )
                }),
        CustomListTile(
          Icons.calendar_today,
          'Calendario',
          () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CalendarioView()))
          },
        ),
        CustomListTile(
            Icons.settings,
            'Configuración',
            () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserView(
                                user: usuario[0],
                              )))
                }),
        if (usuario[0] != null && usuario[0]['charge'] == 'admin') ...[
          CustomListTile(
              Icons.assignment_ind,
              'Area de admin',
              () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AdminArea()))
                  }),
        ] else if (usuario[0] != null && usuario[0]['charge'] == 'user') ...[
          CustomListTile(
              Icons.assignment_late,
              'Tus tareas',
              () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActivityWidget()))
                  })
        ],
        CustomListTile(Icons.power_settings_new, 'Salir', () async {
          await FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }),
      ],
    ),
  );
}

// ignore: must_be_immutable
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

Widget iconoBuscarHaciendas(BuildContext context, List haciendasNuevo) {
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
                context: context,
                delegate: HaciendaSearch(listado: haciendasNuevo));
          })
    ],
    backgroundColor: Colors.green,
    elevation: 0.0,
  );
}

Widget haciendaListado(
  BuildContext context,
  AsyncSnapshot<dynamic> snapshot,
) {
  return SizedBox(
    height: 500,
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          padding: EdgeInsets.only(right: 15.0, left: 10),
          child: GridView.builder(
              itemCount: snapshot.data.length,
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
                                  hacienda: snapshot.data[index]))); //
                    },
                    child: SingleChildScrollView(
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: new Wrap(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Image.network(
                                  snapshot.data[index].data()['imagen']),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Wrap(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Text('Hacienda:'),
                                Text(snapshot.data[index]
                                    .data()['hacienda_name'])
                              ],
                            ),
                            Wrap(
                              direction: Axis.horizontal,
                              children: [
                                Text('Identificación:'),
                                Text(snapshot.data[index]
                                    .data()['id_hacienda']
                                    .toString())
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),
    ),
  );
}

//Implementarlo con la base de datos
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

// Mejorar el metodo de buscar
class HaciendaSearch extends SearchDelegate<dynamic> {
  List listado;
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
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List myList = query.isEmpty
        ? listado
        : listado
            .where((p) => p['id_hacienda'].toString().startsWith(query))
            .toList();
    return myList.isEmpty
        ? Text(
            'No resoults found...',
            style: TextStyle(fontSize: 20),
          )
        : ListView.builder(
            itemCount: myList
                .length, //Aqui esta el problema, si lo pongo listado.length.compareTo(0) entonces solo me deja ver el primer elemento => update, el error era que le estaba pasando el "listado" en vez de "myList"
            itemBuilder: (context, index) {
              QueryDocumentSnapshot nuevoListado = myList[index];
              return FadeIn(
                delay: Duration(milliseconds: 100 * index),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HaciendaView(
                                  hacienda: nuevoListado,
                                )));
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        nuevoListado['hacienda_name'],
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                          'Id hacienda: ' +
                              nuevoListado['id_hacienda'].toString(),
                          style: TextStyle(color: Colors.grey)),
                      Divider()
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(nuevoListado['imagen']),
                  ),
                ),
              );
            });
  }
}
