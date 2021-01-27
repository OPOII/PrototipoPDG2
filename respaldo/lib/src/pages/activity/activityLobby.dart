import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:respaldo/authentication_service.dart';
import 'package:respaldo/src/DatabaseView.dart';
import 'package:respaldo/src/pages/activity/activityView.dart';
import 'package:respaldo/src/services/crud.dart';

class ActivityWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ActividadWidget();
  }
}

class ActividadWidget extends State<ActivityWidget> {
  int cantidadSemanas;
  List haciendas = [];
  List tareas = [];
  CrudConsultas consultas = new CrudConsultas();
  AuthenticationService servicios = new AuthenticationService();
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
    inicio();
    listadoTareas(servicios.currentUser.uid);
  }

  @override
  void dispose() {
    super.dispose();
    connectivityStream.cancel();
  }

  listadoHaciendas() async {
    dynamic resultado = await consultas.obtenerListadoHaciendas();
    setState(() {
      haciendas = resultado;
    });
  }

  listadoTareas(String id) async {
    print(id);
    dynamic resultado = await consultas.obtenerListadoTareasActualUser(id);
    setState(() {
      tareas = resultado;
    });
  }

  void inicio() {
    int dayYear = int.parse(DateFormat("D").format(DateTime.now()));
    DateTime date = new DateTime.now();
    print(dayYear);
    int semana = ((dayYear - date.weekday + 10) / 7).floor();
    print("Estamos en la semana #" + semana.toString() + " del año");
    cantidadSemanas = semana;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0,
            backgroundColor: Colors.green,
            centerTitle: true,
            title: Text(
              "Tareas de la semana #" + cantidadSemanas.toString(),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
        body: ListView.builder(
            itemCount: tareas.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActividadReview(
                                activity: tareas[index],
                              )));
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Hacienda: ' + tareas[index]['Nombre_Hacienda'],
                        style: TextStyle(fontSize: 15)),
                    SizedBox(height: 5.0),
                    Text('Suerte: ' + tareas[index]['Nombre_Suerte'],
                        style: TextStyle(fontSize: 15)),
                    SizedBox(height: 5.0),
                    Text(
                        'Nombre de la tarea: ' +
                            tareas[index]['Nombre_Actividad'].toString(),
                        style: TextStyle(fontSize: 15)),
                    SizedBox(height: 5.0),
                    Text(
                        'Fecha Tarea: ' +
                            tareas[index]['Dia_Inicio'].toString(),
                        style: TextStyle(fontSize: 15)),
                    Divider()
                  ],
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Image.asset('assets/imgs/task.png'),
                ),
              );
            }));
  }
}
