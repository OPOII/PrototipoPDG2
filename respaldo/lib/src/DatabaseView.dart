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
                      label: Text("hdaste"),
                      numeric: false,
                      tooltip: "hdaste",
                    ),
                    DataColumn(
                      label: Text("area"),
                      numeric: false,
                      tooltip: "area",
                    ),
                    DataColumn(
                      label: Text("corte"),
                      numeric: false,
                      tooltip: "corte",
                    ),
                    DataColumn(
                      label: Text("edad"),
                      numeric: false,
                      tooltip: "edad",
                    ),
                    DataColumn(
                      label: Text("nombreActividad"),
                      numeric: false,
                      tooltip: "nombreActividad",
                    ),
                    DataColumn(
                      label: Text("grupo"),
                      numeric: false,
                      tooltip: "grupo",
                    ),
                    DataColumn(
                      label: Text("distrito"),
                      numeric: false,
                      tooltip: "distrito",
                    ),
                    DataColumn(
                      label: Text("tipocultivo"),
                      numeric: false,
                      tooltip: "tipocultivo",
                    ),
                    DataColumn(
                      label: Text("nombrehacienda"),
                      numeric: false,
                      tooltip: "nombrehacienda",
                    ),
                    DataColumn(
                      label: Text("fecha"),
                      numeric: false,
                      tooltip: "fecha",
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
                      label: Text("programa"),
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
                    DataColumn(
                      label: Text("encargado"),
                      numeric: false,
                      tooltip: "encargado",
                    ),
                  ],
                  rows: listado
                      .map(
                        (epa) => DataRow(
                          cells: [
                            DataCell(
                              Text(epa['hdaste']),
                              onTap: () {},
                            ),
                            DataCell(
                              Text(epa['area']),
                            ),
                            DataCell(
                              Text(epa['corte']),
                            ),
                            DataCell(
                              Text(epa['edad']),
                            ),
                            DataCell(
                              Text(epa['nombreActividad']),
                              onTap: () {},
                            ),
                            DataCell(
                              Text(epa['grupo']),
                            ),
                            DataCell(
                              Text(epa['distrito']),
                            ),
                            DataCell(
                              Text(epa['tipoCultivo']),
                            ),
                            DataCell(
                              Text(epa['nombreHacienda']),
                              onTap: () {},
                            ),
                            DataCell(
                              Text(epa['fecha']),
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
                            ),
                            DataCell(
                              Text(epa['pendiente']),
                            ),
                            DataCell(
                              Text(epa['observacion']),
                              onTap: () {},
                            ),
                            DataCell(
                              Text(epa['encargado']),
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
}
