import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:respaldo/controller/form_controller.dart';
import 'package:respaldo/src/pages/tarea/tarea.dart';

class TareaView extends StatefulWidget {
  TareaView({Key key, this.title, builder}) : super(key: key);
  final String title;
  @override
  _TareaViewState createState() => _TareaViewState();
}

// ignore: non_constant_identifier_names
class _TareaViewState extends State<TareaView> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
  TextEditingController haciendaController = TextEditingController();
  TextEditingController suerteController = TextEditingController();
  TextEditingController horasProgramadasController = TextEditingController();
  TextEditingController actividadController = TextEditingController();
  TextEditingController horasEjecutadasController = TextEditingController();
  TextEditingController pendienteController = TextEditingController();
  TextEditingController observacionController = TextEditingController();
  TextEditingController delegadoController = TextEditingController();
  // Method to Submit Feedback and save it in Google Sheets
  void _submitForm() {
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (_formKey.currentState.validate()) {
      // If the form is valid, proceed.
      Tarea feedbackForm = Tarea(
          hdasteController.text,
          areaController.text,
          corteController.text,
          edadController.text,
          nombreActividadController.text,
          grupoController.text,
          distritoController.text,
          tipoCultivoController.text,
          nombreHaciendaController.text,
          fechaController.text,
          haciendaController.text,
          suerteController.text,
          horasProgramadasController.text,
          actividadController.text,
          horasEjecutadasController.text,
          pendienteController.text,
          observacionController.text);

      FormController formController = FormController();

      _showSnackbar("Submitting Feedback");

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
          widget.title,
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
                        CostumTextForField(hdasteController, "HDA-STE"),
                        CostumTextForField(areaController, "Area"),
                        CostumTextForField(corteController, "Corte"),
                        CostumTextForField(edadController, "Edad"),
                        CostumTextForField(nombreActividadController,
                            "Nombre de la actividad"),
                        CostumTextForField(grupoController, "Grupo"),
                        CostumTextForField(
                            tipoCultivoController, "Tipo cultivo"),
                        CostumTextForField(distritoController, "Distrito"),
                        CostumTextForField(
                            nombreHaciendaController, "Nombre de la hacienda"),
                        CostumTextForField(fechaController, "Fecha"),
                        CostumTextForField(haciendaController, "Hacienda"),
                        CostumTextForField(suerteController, "Suerte"),
                        CostumTextForField(
                            horasProgramadasController, "Horas programadas"),
                        CostumTextForField(actividadController, "Actividad"),
                        CostumTextForField(
                            horasEjecutadasController, "Ejecutable"),
                        CostumTextForField(pendienteController, "Pendiente"),
                        CostumTextForField(
                            observacionController, "Observacion"),
                        CostumTextForField(
                            delegadoController, "Encargado de la tarea"),
                      ],
                    ),
                  )),
              RaisedButton(
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: _submitForm,
                child: Text('Submit Feedback'),
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
  CostumTextForField(this.control, this.texto);
  Widget build(BuildContext context) {
    return TextFormField(
      controller: control,
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter Valid Information';
        }
        return null;
      },
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(labelText: texto),
    );
  }
}
