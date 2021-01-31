import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:respaldo/src/pages/Database.dart';
import 'package:respaldo/src/pages/tarea/tarea.dart';
import 'package:respaldo/src/services/crud.dart';

class DatabaseInfo extends StatefulWidget {
  @override
  DatabaseView createState() => DatabaseView();
}

class DatabaseView extends State<DatabaseInfo> {
  static final coleccionBasesDatos = "repositorio";
  List<Map<String, dynamic>> listado;
  List<Tarea> tarea;
  TextEditingController ejecutableController = new TextEditingController();
  StreamSubscription connectivityStream;
  ConnectivityResult oldres;
  CrudConsultas consultas = new CrudConsultas();
  bool dialogshown = false;
  int idActualizar = 0;
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
      } else if (oldres == ConnectivityResult.none) {
        checkInternet().then((result) {
          if (result == true) {
            if (dialogshown == true) {
              dialogshown = false;
            }
          }
        });
      }
      oldres = resu;
    });
    convertir();
  }

  @override
  void dispose() {
    super.dispose();
    connectivityStream.cancel();
  }

  convertir() async {
    dynamic resultado = await DataBaseOffLine.instance.queryAll();
    setState(() {
      tarea = resultado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Base de datos offline"),
      ),
      //Para evitar que haya un overflow, lo primero que se debe de hacer es
      //atrapar todo el widget container para que scrollee hacia abajo como algo normal
      //Luego, en el container meto la tabla y de ahi atrapo el container con el scroll
      //para poder scrollear de manera vertical
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Column(
                  children: [
                    DataTable(
                      columns: [
                        DataColumn(
                          label: Text("ID"),
                          numeric: false,
                          tooltip: "ID",
                        ),
                        DataColumn(
                          label: Text("Hacineda"),
                          numeric: false,
                          tooltip: "Hacienda",
                        ),
                        DataColumn(
                          label: Text("Suerte"),
                          numeric: false,
                          tooltip: "Suerte",
                        ),
                        DataColumn(
                          label: Text("  Hectareas \nprogramadas"),
                          numeric: false,
                          tooltip: "programa",
                        ),
                        DataColumn(
                          label: Text("Actividad"),
                          numeric: false,
                          tooltip: "Actividad",
                        ),
                        DataColumn(
                          label: Text("Ejecutable"),
                          numeric: false,
                          tooltip: "Ejecutable",
                        ),
                        DataColumn(
                          label: Text("Pendiente"),
                          numeric: false,
                          tooltip: "Pendiente",
                        ),
                        DataColumn(
                          label: Text("Observacion"),
                          numeric: false,
                          tooltip: "Observacion",
                        ),
                      ],
                      rows: tarea
                          .map(
                            (epa) => DataRow(
                              cells: [
                                DataCell(
                                  Text(epa.id.toString()),
                                ),
                                DataCell(
                                  Center(child: Text(epa.hacienda)),
                                ),
                                DataCell(
                                  Center(child: Text(epa.suerte)),
                                ),
                                DataCell(
                                  Center(child: Text(epa.programa)),
                                ),
                                DataCell(
                                  Center(child: Text(epa.actividad)),
                                ),
                                DataCell(
                                  Center(child: Text(epa.ejecutable)),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => SimpleDialog(
                                        title: Text(
                                            'Inserte el número de hectareas realizadas hasta ahora'),
                                        children: <Widget>[
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: ejecutableController,
                                            validator: (input) {
                                              if (input.isEmpty) {
                                                return 'Por favor no deje el campo vacio';
                                              }
                                              return null;
                                            },
                                          ),
                                          Center(
                                            child: FlatButton(
                                              child: Text('Guardar'),
                                              onPressed: () {
                                                if (ejecutableController.text ==
                                                    "") {
                                                  return "No se puede ingresar un campo vacio";
                                                } else {
                                                  setState(
                                                    () {
                                                      updateRow(
                                                          ejecutableController
                                                              .text,
                                                          epa.id);
                                                      idActualizar = epa.id;
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                DataCell(
                                  Center(child: buildText(epa)),
                                ),
                                DataCell(
                                  Center(child: Text(epa.observacion)),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [buildFlatButton(), buildBotonEnviarYTerminar()],
            ),
          ],
        ),
      ),
    );
  }

  FlatButton buildFlatButton() {
    if (dialogshown == false) {
      return FlatButton(
        child: Text('Actualizar'),
        onPressed: () {
          enviarYActualizarTabla();
        },
      );
    } else {
      return FlatButton(child: Text('Actualizar'), onPressed: null);
    }
  }

  FlatButton buildBotonEnviarYTerminar() {
    DateTime viernes = new DateTime.now();
    if (viernes.weekday == 6 && dialogshown == false) {
      return FlatButton(
        child: Text('Enviar y terminar'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: Text(
                  'Al enviar y terminar todo se borrara la tabla que tiene y no podra volver a guardar los datos ni actualizarlos, ¿Esta seguro que desea terminar?'),
              children: <Widget>[
                /*TextFormField(
                  keyboardType: TextInputType.number,
                  controller: ejecutableController,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Por favor no deje el campo vacio';
                    }
                    return null;
                  },
                ),
                */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FlatButton(child: Text('SI'), onPressed: () {}),
                    FlatButton(child: Text('No'), onPressed: () {})
                  ],
                ),
              ],
            ),
          );
        },
      );
    } else {
      return FlatButton(child: Text('Enviar y terminar'), onPressed: null);
    }
  }

  enviarYActualizarTabla() async {
    for (var i = 0; i < tarea.length; i++) {
      DocumentReference ref = FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection(coleccionBasesDatos)
          .doc(tarea[i].id.toString());
      ref.update({'ejecutable': double.tryParse(tarea[i].ejecutable)});
      ref.update({'pendiente': double.tryParse(tarea[i].pendiente)});
    }
    /*print(tarea[0].ejecutable);
    final snapshot = await FirebaseFirestore.instance
        .collection('Ingenio')
        .doc('1')
        .collection('repositorio')
        .get();
    if (snapshot.docs.length == 0) {
      consultas.insumoDiaLunesAdmin();
    }
    print(snapshot.docs.length.toString() + " A ver");
    //tarea[0].ejecutable = "1.5";
    */
  }

  enviarYBorrarTabla() async {}

  updateRow(String referencia, epa) {
    DataBaseOffLine.instance.update({
      DataBaseOffLine.columnId: epa,
      DataBaseOffLine.columnejecutable: referencia
    });
    Navigator.pop(context);
  }

  Text buildText(Tarea epa) {
    double ejecutable = double.tryParse(epa.ejecutable);
    double programadas = double.tryParse(epa.programa);
    double respuesta = programadas - ejecutable;
    respuesta.toStringAsFixed(2);
    if (respuesta < 0) {
      return Text("");
    } else {
      epa.pendiente = respuesta.toStringAsFixed(2);
      return Text(respuesta.toStringAsFixed(2));
    }
  }
}
