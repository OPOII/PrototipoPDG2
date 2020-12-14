import 'package:flutter/material.dart';

class Tabla extends StatefulWidget {
  @override
  TablaDatos createState() {
    return new TablaDatos();
  }
}

// ignore: camel_case_types
class TablaDatos extends State<Tabla> {
  Widget bodyData() => DataTable(
      onSelectAll: (b) {},
      sortColumnIndex: 1,
      sortAscending: true,
      columns: <DataColumn>[
        DataColumn(
          label: Text("Nombre Hacienda"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              activities
                  .sort((a, b) => a.haciendaName.compareTo(b.haciendaName));
            });
          },
          tooltip: "To display last name of the Name",
        ),
        DataColumn(
          label: Text("Fecha de Inicio"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              activities.sort((a, b) => a.startdate.compareTo(b.startdate));
            });
          },
          tooltip: "To display last name of the Name",
        ),
        DataColumn(
          label: Text("Nombre suerte"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              activities.sort((a, b) => a.suerteName.compareTo(b.suerteName));
            });
          },
        ),
        DataColumn(
          label: Text("Horas programadas"),
          numeric: true,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              activities
                  .sort((a, b) => a.programedHours.compareTo(b.programedHours));
            });
          },
          tooltip: "To display last name of the Name",
        ),
        DataColumn(
          label: Text("Nombre Actividad"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              activities
                  .sort((a, b) => a.activityName.compareTo(b.activityName));
            });
          },
          tooltip: "To display last name of the Name",
        ),
        DataColumn(
          label: Text("Horas Realizadas"),
          numeric: true,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              activities.sort((a, b) => a.hoursDone.compareTo(b.hoursDone));
            });
          },
          tooltip: "To display last name of the Name",
        ),
        DataColumn(
          label: Text("Horas Faltantes"),
          numeric: true,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              activities
                  .sort((a, b) => a.missingHours.compareTo(b.missingHours));
            });
          },
          tooltip: "To display last name of the Name",
        ),
        DataColumn(
          label: Text("Observaciones"),
          numeric: false,
          onSort: (i, b) {
            print("$i $b");
            // setState(() {
            //  activities.sort((a, b) => a.activityName.compareTo(b.activityName));
            //});
          },
          tooltip: "To display last name of the Name",
        ),
        DataColumn(
          label: Text("id suerte"),
          numeric: true,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              activities.sort((a, b) => a.idSuerte.compareTo(b.idSuerte));
            });
          },
          tooltip: "To display last name of the Name",
        ),
        DataColumn(
          label: Text("id Actividad"),
          numeric: true,
          onSort: (i, b) {
            print("$i $b");
            setState(() {
              activities.sort((a, b) => a.idActivity.compareTo(b.idActivity));
            });
          },
          tooltip: "To display last name of the Name",
        ),
      ],
      rows: activities
          .map(
            (activities) => DataRow(
              cells: [
                DataCell(
                  Text(activities.haciendaName),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(activities.startdate.toString()),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(activities.suerteName),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(activities.programedHours.toString()),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(activities.activityName),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(activities.hoursDone.toString()),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(activities.missingHours.toString()),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(activities.observations),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(activities.idSuerte.toString()),
                  showEditIcon: false,
                  placeholder: false,
                ),
                DataCell(
                  Text(activities.idActivity.toString()),
                  showEditIcon: false,
                  placeholder: false,
                )
              ],
            ),
          )
          .toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tabla de datos"),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical, child: bodyData()),
    );
  }
}

class FlittedBox {}

class Activity {
  String haciendaName;
  DateTime startdate;
  String suerteName;
  double programedHours;
  String activityName;
  double hoursDone;
  double missingHours;
  String observations;
  int idSuerte;
  int idActivity;

  Activity(
      {this.haciendaName,
      this.startdate,
      this.suerteName,
      this.programedHours,
      this.activityName,
      this.hoursDone,
      this.missingHours,
      this.observations,
      this.idSuerte,
      this.idActivity});
}

var activities = <Activity>[
  Activity(
      haciendaName: "Manuelita",
      startdate: DateTime.parse("2020-10-11"),
      suerteName: "294 SST",
      programedHours: 8.5,
      activityName: "Riego",
      hoursDone: 8.5,
      missingHours: 0.0,
      observations: "Trabajo terminado sin problema",
      idSuerte: 294,
      idActivity: 1),
  Activity(
      haciendaName: "La cabaña",
      startdate: DateTime.parse("2020-08-05"),
      suerteName: "111 SECTOR 2",
      programedHours: 3.0,
      activityName: "Riego",
      hoursDone: 2.0,
      missingHours: 1.0,
      observations: "falta de tiempo",
      idSuerte: 111,
      idActivity: 1),
  Activity(
      haciendaName: "PICHICHI S.A.",
      startdate: DateTime.parse("2020-09-25"),
      suerteName: "335 BBC",
      programedHours: 10.0,
      activityName: "Riego",
      hoursDone: 9.0,
      missingHours: 1.0,
      observations: "falta de tiempo",
      idSuerte: 335,
      idActivity: 1),
];
