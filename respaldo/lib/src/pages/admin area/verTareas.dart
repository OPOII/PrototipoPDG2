import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:respaldo/src/DatabaseView.dart';
import 'package:respaldo/src/pages/tarea/tareaView.dart';
import 'package:respaldo/src/services/crud.dart';

class AllTasks extends StatefulWidget {
  @override
  _AlltasksState createState() => _AlltasksState();
}

class _AlltasksState extends State<AllTasks> {
  CrudConsultas consultas = new CrudConsultas();
  List haciendas = [];
  List suertes = [];
  List usuarios = [];
  List tareas = [];
  String currentHacienda;
  String currentSuerte;
  String currentUser;
  List<DropdownMenuItem<String>> menuHaciendas;
  List<DropdownMenuItem<String>> menuSuertes;
  List<DropdownMenuItem<String>> menuUsuarios;
  ConnectivityResult oldres;
  StreamSubscription connectivityStream;
  bool dialogshown = false;
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
    obtenerHaciendas();
    obtenerUsuarios();
    currentHacienda = "";
    currentSuerte = "";
    currentUser = "";
  }

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
  void dispose() {
    super.dispose();
    connectivityStream.cancel();
  }

  buscarFiltros(String hacienda, String suerte, String usuario) async {
    //Buscar solo por hacienda
    if (suerte == "" && usuario == "") {
      dynamic resultado = await consultas.buscarPorHacienda(hacienda);
      setState(() {
        tareas = resultado;
      });
    }
    //Buscar por hacienda y suerte
    else if (usuario == "") {
      dynamic resultado =
          await consultas.buscarPorHaciendaSuerte(hacienda, suerte);
      setState(() {
        tareas = resultado;
      });
    }
    //Buscar solo por usuario
    else if (hacienda == "" && suerte == "") {
      dynamic resultado = await consultas.buscarPorUsuario(usuario);
      setState(() {
        tareas = resultado;
      });
    }
    //Buscar por hacienda y usuario
    else if (suerte == "") {
      dynamic resultado =
          await consultas.buscarPorHaciendaUsuario(hacienda, usuario);
      setState(() {
        tareas = resultado;
      });
    }
    //Buscar por los tres
    else if (hacienda != "" && suerte != "" && usuario != "") {
      dynamic resultado = await consultas.buscarPorHaciendaSuerteUsuario(
          hacienda, suerte, usuario);
      setState(() {
        tareas = resultado;
      });
    } else {
      dynamic resultado = await consultas.traerTodasLasTareas();
      setState(() {
        tareas = resultado;
      });
    }
  }

  obtenerHaciendas() async {
    dynamic resultado = await consultas.obtenerListadoHaciendas();
    setState(() {
      haciendas = resultado;
      List<DropdownMenuItem<String>> items = new List();
      items.add(new DropdownMenuItem(value: "", child: Text("")));
      for (int i = 0; i < haciendas.length; i++) {
        items.add(new DropdownMenuItem(
          value: haciendas[i]['hacienda_name'],
          child: Text(haciendas[i]['hacienda_name']),
        ));
      }
      menuHaciendas = items;
    });
  }

  obtenerUsuarios() async {
    dynamic resultado = await consultas.obtenerListadoUsuarios();
    setState(() {
      usuarios = resultado;
      List<DropdownMenuItem<String>> items = new List();
      items.add(new DropdownMenuItem(value: "", child: Text("")));
      for (int i = 0; i < usuarios.length; i++) {
        items.add(new DropdownMenuItem(
          value: usuarios[i]['name'],
          child: Text(usuarios[i]['name']),
        ));
      }
      menuUsuarios = items;
    });
  }

  obtenerSuertes(String id) async {
    if (id != "") {
      dynamic resultado = await consultas.obtenerListadoSuertes(id);
      setState(() {
        suertes = resultado;
        List<DropdownMenuItem<String>> items = new List();
        items.add(new DropdownMenuItem(value: "", child: Text("")));
        for (int i = 0; i < suertes.length; i++) {
          items.add(new DropdownMenuItem(
            value: suertes[i]['id_suerte'],
            child: Text(suertes[i]['id_suerte']),
          ));
        }
        menuSuertes = items;
      });
    }
  }

  void changedHaciendaItem(String change) {
    setState(() {
      currentHacienda = change;
    });
    String id = "";
    if (currentHacienda != "" || currentHacienda != "seleccione una hacienda") {
      for (int i = 0; i < haciendas.length; i++) {
        if (haciendas[i]['hacienda_name'] == currentHacienda) {
          id = haciendas[i]['clave_hacienda'];
        }
      }
      currentSuerte = "";
      obtenerSuertes(id);
    }
    if (currentHacienda == "") {
      setState(() {
        menuSuertes.clear();
        menuSuertes.add(new DropdownMenuItem(value: "", child: Text("")));
      });
    }
  }

  void changedSuerteItem(String change) {
    setState(() {
      currentSuerte = change;
    });
  }

  void changedUsuarioItem(String change) {
    setState(() {
      currentUser = change;
    });
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
          "Todas las tareas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Text('Filtrar Busqueda',
                        style: TextStyle(fontSize: 20)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Filtrar por haciendas",
                          style: TextStyle(fontSize: 18)),
                      DropdownButton(
                        value: currentHacienda,
                        items: menuHaciendas,
                        onChanged: changedHaciendaItem,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Filtrar por suertes",
                          style: TextStyle(fontSize: 18)),
                      DropdownButton(
                          value: currentSuerte,
                          items: menuSuertes,
                          onChanged: changedSuerteItem)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Encargado", style: TextStyle(fontSize: 20)),
                      DropdownButton(
                          value: currentUser,
                          items: menuUsuarios,
                          onChanged: changedUsuarioItem)
                    ],
                  ),
                  RaisedButton(
                      color: Colors.blue,
                      child: Text('Buscar'),
                      onPressed: () {
                        buscarFiltros(
                            currentHacienda, currentSuerte, currentUser);
                      }),
                  listadoFiltradoTareas(context, tareas),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget listadoFiltradoTareas(BuildContext context, List tareas) {
  return tareas.isEmpty
      ? Container(
          child: Image.asset("assets/imgs/no_task_vector.png"),
          color: Colors.transparent,
        )
      : ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: tareas.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskView(task: tareas[index])));
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Hacienda:  ' +
                      tareas[index]['Nombre_Hacienda'].toString()),
                  Text('Suerte:  ' + tareas[index]['Nombre_Suerte'].toString()),
                  Text(
                      'Encargado:' +
                          tareas[index]['Usuario_Encargado'].toString(),
                      style: TextStyle(color: Colors.grey)),
                  Divider()
                ],
              ),
              leading: CircleAvatar(
                  child: Image.asset("assets/imgs/taskDone.png"),
                  backgroundColor: Colors.transparent),
            );
          });
}
