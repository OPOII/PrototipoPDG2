import 'package:flutter/material.dart';
import 'package:respaldo/src/pages/Database.dart';
import 'package:respaldo/src/pages/tarea/tarea.dart';
import 'package:respaldo/src/services/crud.dart';

class DatabaseInfo extends StatefulWidget {
  @override
  DatabaseView createState() => DatabaseView();
}

class DatabaseView extends State<DatabaseInfo> {
  List<Map<String, dynamic>> listado;
  TextEditingController ejecutableController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    convertir();
  }

  agregarTareas(List<Tarea> listado) {
    for (var i = 0; i < listado.length; i++) {
      DataBaseOffLine.instance.insert({
        DataBaseOffLine.columnhdaste: listado[i].hdaste,
        DataBaseOffLine.columnarea: listado[i].area,
        DataBaseOffLine.columncorte: listado[i].corte,
        DataBaseOffLine.columnedad: listado[i].edad,
        DataBaseOffLine.columnnombreActividad: listado[i].nombreActividad,
        DataBaseOffLine.columngrupo: listado[i].grupo,
        DataBaseOffLine.columndistrito: listado[i].distrito,
        DataBaseOffLine.columntipoCultivo: listado[i].tipoCultivo,
        DataBaseOffLine.columnnombreHacienda: listado[i].nombreHacienda,
        DataBaseOffLine.columnfecha: listado[i].fecha,
        DataBaseOffLine.columnhacienda: listado[i].hacienda,
        DataBaseOffLine.columnsuerte: listado[i].suerte,
        DataBaseOffLine.columnprograma: listado[i].programa,
        DataBaseOffLine.columnactividad: listado[i].actividad,
        DataBaseOffLine.columnejecutable: listado[i].ejecutable,
        DataBaseOffLine.columnpendiente: listado[i].pendiente,
        DataBaseOffLine.columnobservacion: listado[i].observacion,
        DataBaseOffLine.columnencargado: listado[i].encargado,
      });
    }
  }

  convertir() async {
    dynamic resultado = await DataBaseOffLine.instance.queryAll();
    setState(() {
      listado = resultado;
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            child: Column(
              children: [
                DataTable(
                  columns: [
                    DataColumn(
                      label: Text("id"),
                      numeric: false,
                      tooltip: "id",
                    ),
                    DataColumn(
                      label: Text("hacienda"),
                      numeric: false,
                      tooltip: "hacienda",
                    ),
                    DataColumn(
                      label: Text("suerte"),
                      numeric: false,
                      tooltip: "suerte",
                    ),
                    DataColumn(
                      label: Text("Hectareas \nprogramadas"),
                      numeric: false,
                      tooltip: "programa",
                    ),
                    DataColumn(
                      label: Text("actividad"),
                      numeric: false,
                      tooltip: "actividad",
                    ),
                    DataColumn(
                      label: Text("ejecutable"),
                      numeric: false,
                      tooltip: "ejecutable",
                    ),
                    DataColumn(
                      label: Text("pendiente"),
                      numeric: false,
                      tooltip: "pendiente",
                    ),
                    DataColumn(
                      label: Text("observacion"),
                      numeric: false,
                      tooltip: "observacion",
                    ),
                  ],
                  rows: listado
                      .map(
                        (epa) => DataRow(
                          cells: [
                            DataCell(
                              Text(epa['id'].toString()),
                              onTap: null,
                            ),
                            DataCell(
                              Text(epa['hacienda']),
                            ),
                            DataCell(
                              Text(epa['suerte']),
                            ),
                            DataCell(
                              Text(epa['programa']),
                              onTap: () {},
                            ),
                            DataCell(
                              Text(epa['actividad']),
                            ),
                            DataCell(
                              Text(epa['ejecutable']),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => SimpleDialog(
                                          title: Text(
                                              'Inserte el número de hectareas realizadas hasta ahora'),
                                          children: <Widget>[
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
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
                                                if (ejecutableController
                                                    .text.isEmpty) {
                                                } else {
                                                  updateRow(
                                                      ejecutableController.text,
                                                      epa['id']);
                                                }
                                              },
                                            ))
                                          ],
                                        ));

                                print(epa['id']);
                              },
                            ),
                            DataCell(
                              buildText(epa),
                            ),
                            DataCell(
                              Text(epa['observacion']),
                              onTap: () {},
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
      ),
    );
  }

  updateRow(String referencia, epa) {
    DataBaseOffLine.instance.update({
      DataBaseOffLine.columnId: epa,
      DataBaseOffLine.columnejecutable: referencia
    });
    Navigator.pop(context);
  }

  Text buildText(Map<String, dynamic> epa) {
    double ejecutable = double.tryParse(epa['ejecutable']);
    double programadas = double.tryParse(epa['programa']);
    double respuesta = programadas - ejecutable;
    if (respuesta < 0) {
      return Text("");
    } else {
      return Text(respuesta.toStringAsFixed(2));
    }
  }
}
