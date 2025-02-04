import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:respaldo/src/DatabaseView.dart';
import 'package:respaldo/src/services/crud.dart';
import 'package:intl/intl.dart';
import 'package:respaldo/src/services/notificationServices.dart';

class TareaView extends StatefulWidget {
  TareaView({Key key, this.title, builder}) : super(key: key);
  final String title;
  @override
  _TareaViewState createState() => _TareaViewState();
}

// ignore: non_constant_identifier_names
class _TareaViewState extends State<TareaView> {
  ConnectivityResult oldres;
  StreamSubscription connectivityStream;
  bool dialogshown = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime fecha;
  final format = DateFormat("dd-MM-yyyy");
  CrudConsultas consultas = new CrudConsultas();
  Services servicios = new Services();
  List<DropdownMenuItem<String>> menuHaciendas;
  List<DropdownMenuItem<String>> menuSuertes;
  List<DropdownMenuItem<String>> menuUsuarios;
  List haciendas = [];
  List suertes = [];
  List usuarios = [];
  String currentHacienda;
  String currentSuerte;
  String currentUser;
  String idUser = "";
  String idHacienda = "";
  String idSuerte = "";
  String message = "";
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
    currentHacienda = "seleccione una hacienda";
    currentSuerte = "";
    currentUser = "";
  }

  @override
  void dispose() {
    super.dispose();
    connectivityStream.cancel();
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

  // ignore: non_constant_identifier_names
  TextEditingController hdasteController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController corteController = TextEditingController();
  TextEditingController edadController = TextEditingController();
  TextEditingController nombreActividadController = TextEditingController();
  TextEditingController grupoController = TextEditingController();
  TextEditingController distritoController = TextEditingController();
  TextEditingController tipoCultivoController = TextEditingController();
  TextEditingController nombreHaciendaController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController horasProgramadasController = TextEditingController();
  TextEditingController actividadController = TextEditingController();
  TextEditingController horasEjecutadasController = TextEditingController();
  TextEditingController pendienteController = TextEditingController();
  TextEditingController observacionController = TextEditingController();
  TextEditingController delegadoController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  // Method to Submit Feedback and save it in Google Sheets
  Future<void> _submitForm() async {
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (_formKey.currentState.validate()) {
      //FormController formController = FormController();
      _showSnackbar("Se esta agregando la tarea");
      Map<String, dynamic> planSemanal = new Map<String, dynamic>();
      Map<String, dynamic> tareaUsuario = new Map<String, dynamic>();
      planSemanal['HDA-STE'] = hdasteController.text;
      planSemanal['Area'] = areaController.text;
      planSemanal['Corte'] = corteController.text;
      planSemanal['Edad'] = int.tryParse(edadController.text);
      planSemanal['Nombre_Actividad'] = nombreActividadController.text;
      planSemanal['Grupo'] = grupoController.text;
      planSemanal['Tipo_Cultivo'] = tipoCultivoController.text;
      planSemanal['Distrito'] = distritoController.text;
      planSemanal['Fecha_Inicio'] = fechaController.text;
      planSemanal['Hacienda_Asignada'] = currentHacienda;
      obtenerClaveHacienda(currentHacienda);
      planSemanal['Clave_Hacienda'] = idHacienda;
      obtenerClaveSuerte(currentSuerte, idHacienda);
      planSemanal['Clave_Suerte'] = idSuerte;
      planSemanal['Suerte_Asignada'] = currentSuerte;
      planSemanal['Horas_programadas'] =
          int.tryParse(horasProgramadasController.text);
      planSemanal['Actividad'] = actividadController.text;
      planSemanal['Ejecutable'] = 0;
      planSemanal['Pendiente'] = int.tryParse(horasProgramadasController.text);
      planSemanal['Observacion'] = "";
      planSemanal['Usuario_Encargado'] = currentUser;
      obtenerIdUsuario(currentUser);
      planSemanal['Id_usuario'] = idUser;
      print(planSemanal);
      //Guardo esto en plan semanal
      DocumentReference referencia = await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('plansemanal')
          .add(planSemanal);
      referencia.update({'Id_Tarea': referencia.id});
      tareaUsuario['Nombre_Hacienda'] = currentHacienda;
      tareaUsuario['Dia_Inicio'] = fechaController.text;
      tareaUsuario['Nombre_Suerte'] = currentSuerte;
      tareaUsuario['Horas_Programadas'] =
          int.tryParse(horasProgramadasController.text);
      tareaUsuario['Nombre_Actividad'] = actividadController.text;
      tareaUsuario['Horas_Hechas'] = 0;
      tareaUsuario['Horas_Faltantes'] =
          int.tryParse(horasProgramadasController.text);
      tareaUsuario['Observacion'] = "";
      tareaUsuario['Observacion_tarea'] = messageController.text;
      tareaUsuario['Terminado'] = false;
      tareaUsuario['Clave_Hacienda'] = idHacienda;
      tareaUsuario['Clave_Suerte'] = idSuerte;
      tareaUsuario['Id_Actividad'] = referencia.id;
      tareaUsuario['Usuario_Encargado'] = currentUser;
      tareaUsuario['Id_Usuario'] = idUser;
      //Guardo esto en la coleccion de tareas de los usuarios
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('users')
          .doc(idUser)
          .collection('tareas')
          .doc(referencia.id)
          .set(tareaUsuario);

      //Obtengo la referencia del usuario para poder mirar si la hacienda que se le encargo ya la tenia encargada
      DocumentReference overwrite = FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('users')
          .doc(idUser);
      //Obtengo el listado de las haciendas del usuario loggeado en la app
      DocumentSnapshot listadoHacienda = await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('users')
          .doc(idUser)
          .get();
      //Paso el listado de las haciendas para ver cuales tiene y luego compararlas con la que le voy a pasar
      //Si ya la tiene encargada, no se la paso, sin embargo, si no la tiene encargada, se la paso.
      List<dynamic> haciendasEncargadas =
          listadoHacienda.get("haciendasResponsables");
      if (!(haciendasEncargadas.contains(currentHacienda))) {
        var list = List<dynamic>();
        list.add(currentHacienda);
        print('No la contiene y entro en este condicional');
        overwrite
            .update({'haciendasResponsables': FieldValue.arrayUnion(list)});
      }
      /* DocumentReference poolTasks = await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('tasks')
          .add(tareaUsuario);
      poolTasks.update({'Id_task': poolTasks.id});
      */
      enviarNotificacion();
      _showSnackbar("La tarea se agrego exitosamente");
      //clearData();
      // Submit 'feedbackForm' and save it in Google Sheets.
      //formController.submitForm(feedbackForm, (String response) {
      // print("Response: $response");
      //if (response == FormController.STATUS_SUCCESS) {
      // Feedback is saved succesfully in Google Sheets.
      //  _showSnackbar("Feedback Submitted");
      //} else {
      // Error Occurred while saving data in Google Sheets.
      //  _showSnackbar("Error Occurred!");
      //}
      // });
    }
  }

/**
 * Este metodo busca en la lista de los usuarios cual coincide con el id 
 * que se escogio. Al encontrarlo, se llama al metodo que esta en la clase servicios
 * para enviar la notificación al usuario en cuestion.
 */
  void enviarNotificacion() async {
    for (var i = 0; i < usuarios.length; i++) {
      if (usuarios[i]['id_user'] == idUser) {
        await servicios.sendAndRetrieveMessage(usuarios[i]['Token_ID'],
            "Nueva tarea: " + actividadController.text, messageController.text);
      }
    }
  }

  void clearData() {
    hdasteController.text = "";
    areaController.text = "";
    corteController.text = "";
    edadController.text = "";
    nombreActividadController.text = "";
    grupoController.text = "";
    tipoCultivoController.text = "";
    distritoController.text = "";
    fechaController.text = "";
    currentHacienda = "seleccione una hacienda";
    currentSuerte = "";
    horasProgramadasController.text = "";
    actividadController.text = "";
    currentUser = "";
    observacionController.text = "";
    currentSuerte = "";
    messageController.text = "";
  }

  obtenerHaciendas() async {
    dynamic resultado = await consultas.obtenerListadoHaciendas();
    setState(() {
      haciendas = resultado;
      List<DropdownMenuItem<String>> items = new List();
      items.add(new DropdownMenuItem(
          value: "seleccione una hacienda",
          child: Text("seleccione una hacienda")));
      for (int i = 0; i < haciendas.length; i++) {
        items.add(new DropdownMenuItem(
          value: haciendas[i]['hacienda_name'],
          child: Text(haciendas[i]['hacienda_name']),
        ));
      }
      menuHaciendas = items;
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

  void obtenerIdUsuario(String nombre) async {
    for (var i = 0; i < usuarios.length; i++) {
      if (usuarios[i]['name'] == nombre) {
        setState(() {
          idUser = usuarios[i]['id_user'];
        });
      }
    }

    dynamic resultado = await consultas.obtenerIdUsuario(nombre);
    setState(() {
      idUser = resultado;
    });
  }

  void obtenerClaveHacienda(String nombre) async {
    for (var i = 0; i < haciendas.length; i++) {
      if (haciendas[i]['hacienda_name'] == nombre) {
        setState(() {
          idHacienda = haciendas[i]['clave_hacienda'];
        });
      }
    }
  }

  void obtenerClaveSuerte(String nombreSuerte, String idHacienda) async {
    for (var i = 0; i < suertes.length; i++) {
      if (suertes[i]['id_suerte'] == nombreSuerte) {
        setState(() {
          idSuerte = suertes[i]['claveSuerte'];
        });
      }
    }
  }

  _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "Asignar Tarea",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CostumTextForField(hdasteController, "HDA-STE",
                            TextInputType.multiline),
                        CostumTextForField(
                            areaController, "Area", TextInputType.number),
                        CostumTextForField(
                            corteController, "Corte", TextInputType.number),
                        CostumTextForField(
                            edadController, "Edad", TextInputType.number),
                        CostumTextForField(nombreActividadController,
                            "Nombre de la actividad", TextInputType.multiline),
                        CostumTextForField(
                            grupoController, "Grupo", TextInputType.multiline),
                        CostumTextForField(tipoCultivoController,
                            "Tipo cultivo", TextInputType.multiline),
                        CostumTextForField(distritoController, "Distrito",
                            TextInputType.multiline),
                        DateTimeField(
                          controller: fechaController,
                          decoration: InputDecoration(
                              labelText: 'Fecha Inicio',
                              suffixIcon: Icon(Icons.calendar_today)),
                          format: format,
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                initialDate: currentValue ?? DateTime.now(),
                                firstDate: DateTime(1920),
                                lastDate: DateTime(2030));
                          },
                          onSaved: (value) {
                            fecha = value;
                          },
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return "Debes de elegir una fecha de nacimiento";
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Hacienda", style: TextStyle(fontSize: 20)),
                            DropdownButton(
                                value: currentHacienda,
                                items: menuHaciendas,
                                onChanged: changedHaciendaItem)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Suerte", style: TextStyle(fontSize: 20)),
                            DropdownButton(
                                value: currentSuerte,
                                items: menuSuertes,
                                onChanged: changedSuerteItem)
                          ],
                        ),
                        CostumTextForField(horasProgramadasController,
                            "Horas programadas", TextInputType.number),
                        CostumTextForField(actividadController, "Actividad",
                            TextInputType.multiline),
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
                        TextFormField(
                          controller: messageController,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please, enter a description';
                            }
                            return null;
                          },
                          onSaved: (input) => message = input,
                          decoration: InputDecoration(
                              hintText: 'Cuerpo de la notificación',
                              labelText:
                                  'Entre la descripción de la notificación',
                              border: OutlineInputBorder()),
                          maxLines: 10,
                        )
                      ],
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: _submitForm,
                    child: Text('Agregar tarea'),
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: clearData,
                    child: Text('Limpiar datos'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CostumTextForField extends StatelessWidget {
  TextEditingController control;
  String texto;
  TextInputType tipoTeclado;
  CostumTextForField(this.control, this.texto, this.tipoTeclado);
  Widget build(BuildContext context) {
    return TextFormField(
      controller: control,
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter Valid Information';
        }
        return null;
      },

      keyboardType: tipoTeclado,
      //keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: texto,
      ),
    );
  }
}
