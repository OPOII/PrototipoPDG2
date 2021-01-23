import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskView extends StatefulWidget {
  final dynamic task;
  TaskView({Key key, this.task}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TaskView(task);
}

class _TaskView extends State<TaskView> {
  dynamic task;
  _TaskView(this.task);
  TextEditingController observacionTareaController = TextEditingController();
  TextEditingController observacionUsuarioController = TextEditingController();
  TextEditingController enviarComentarioController = TextEditingController();
  String texto;
  @override
  void initState() {
    super.initState();
    observacionTareaController.text = task['Observacion_tarea'].toString();
    observacionUsuarioController.text = task['Observacion'].toString();
  }

  enviarComentario() async {
    //Actualizo el comentario que tenian de la tarea
    await FirebaseFirestore.instance
        .collection('Ingenio')
        .doc('1')
        .collection('tasks')
        .doc(task['Id_Actividad'])
        .update({'Observacion_tarea': enviarComentarioController.text});
    //Obtener la istancia del documento actualizado para poder pasar por parametro
    //La información al usuario
    DocumentSnapshot referencia = await FirebaseFirestore.instance
        .collection('Ingenio')
        .doc('1')
        .collection('tasks')
        .doc(task['Id_Actividad'])
        .get();
    //Reenviar la tarea al que se le asigno con las actualizaciones que se hicieron
    await FirebaseFirestore.instance
        .collection('Ingenio')
        .doc('1')
        .collection('users')
        .doc(task['Id_Usuario'])
        .collection('tareas')
        .doc(task['Id_Actividad'])
        .set(referencia.data());
    //Borro de la base de datos el documento de la coleccion de tasks  y se la paso al usuario
    await FirebaseFirestore.instance
        .collection('Ingenio')
        .doc('1')
        .collection('tasks')
        .doc(task['Id_Actividad'])
        .delete();
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  terminarTarea() async {
    await FirebaseFirestore.instance
        .collection('Ingenio')
        .doc('1')
        .collection('tasks')
        .doc(task['Id_Actividad'])
        .delete();
    Navigator.pop(context);
    Navigator.pop(context);
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
          "Información de la tarea",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text('Nombre Actividad:',
                        style: TextStyle(fontSize: 20)),
                  ),
                  Flexible(
                    child: Text(task['Nombre_Actividad'].toString(),
                        style: TextStyle(fontSize: 20)),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text('Nombre Hacienda:',
                        style: TextStyle(fontSize: 20)),
                  ),
                  Flexible(
                    child: Text(task['Nombre_Hacienda'].toString(),
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text('Suerte:', style: TextStyle(fontSize: 20)),
                  ),
                  Flexible(
                    child: Text(task['Nombre_Suerte'].toString(),
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text('Horas Programadas:',
                        style: TextStyle(fontSize: 20)),
                  ),
                  Flexible(
                    child: Text(task['Horas_Programadas'].toString(),
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child:
                        Text('Horas Hechas:', style: TextStyle(fontSize: 20)),
                  ),
                  Flexible(
                    child: Text(task['Horas_Hechas'].toString(),
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text('Horas Faltantes:',
                        style: TextStyle(fontSize: 20)),
                  ),
                  Flexible(
                    child: Text(
                        (task['Horas_Programadas'] - task['Horas_Hechas'])
                            .toString(),
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Text('Encargado:', style: TextStyle(fontSize: 20)),
                  ),
                  Flexible(
                    child: Text(task['Usuario_Encargado'].toString(),
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              Center(
                child: Text('Observación de la tarea',
                    style: TextStyle(fontSize: 17)),
              ),
              TextField(
                controller: observacionTareaController,
                maxLines: 4,
              ),
              Center(
                child: Text('Observación del usuario',
                    style: TextStyle(fontSize: 17)),
              ),
              TextField(
                controller: observacionUsuarioController,
                maxLines: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: terminarTarea,
                    child: Text('Aceptar Tarea'),
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    child: Text('Rechazar Tarea'),
                    textColor: Colors.white,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => SimpleDialog(
                                title: Center(
                                  child: Text(
                                      'Por favor ingrese el motivo por el cual rechaza la tarea'),
                                ),
                                children: <Widget>[
                                  TextFormField(
                                    controller: enviarComentarioController,
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Please, enter a description';
                                      }
                                      return null;
                                    },
                                    onSaved: (input) => texto = input,
                                    maxLines: 10,
                                  ),
                                  Center(
                                    child: FlatButton(
                                      child: Text('Done'),
                                      onPressed: enviarComentario,
                                    ),
                                  )
                                ],
                              ));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
