import 'dart:math';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AgregarUsuarios extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UsersState();
}

class _UsersState extends State<AgregarUsuarios> {
  final formKey = GlobalKey<FormState>();
  String name, telephone, email, cargo, hacienda, url;
  DateTime fecha;
  final nameController = TextEditingController();
  final telephoneController = TextEditingController();
  final emailController = TextEditingController();
  final cargoController = TextEditingController();
  final birthdayController = TextEditingController();
  final cedulaController = TextEditingController();
  final format = DateFormat("dd-MM-yyyy");
  List _charges = ["", "admin", "user"];
  String _currentCharge;
  final _datos = [
    {
      "display": "Hacienda #468865",
      "value": "Hacienda #468865",
    },
    {
      "display": "Hacienda #6498633",
      "value": "Hacienda #6498633",
    },
    {
      "display": "Hacienda #268979778",
      "value": "Hacienda #268979778",
    },
    {
      "display": "Hacienda #798626936",
      "value": "Hacienda #798626936",
    },
    {
      "display": "Hacienda #51654687986",
      "value": "Hacienda #51654687986",
    },
  ];
  List<DropdownMenuItem<String>> _dropDownMenuItems;
  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentCharge = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String city in _charges) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: city, child: new Text(city)));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Colors.green,
          centerTitle: true,
          title: Text('Agregar Usuarios',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  onSaved: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Este campo no debe de estar vacio";
                    }
                  },
                ),
                TextFormField(
                  controller: cedulaController,
                  decoration: InputDecoration(labelText: 'Cedula'),
                  onSaved: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Este campo no debe de estar vacio";
                    } else if (int.tryParse(value.toString()) == null) {
                      return "Este campo solo admite numeros";
                    }
                  },
                ),
                TextFormField(
                  controller: telephoneController,
                  decoration: InputDecoration(labelText: 'Telephone'),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    telephone = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Este campo no debe de estar vacio";
                    }
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Este campo no debe de estar vacio";
                    } else if (!(value.contains("@"))) {
                      return "Debes de agregar un correo electronico";
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Charge:", style: TextStyle(fontSize: 20)),
                    DropdownButton(
                      value: _currentCharge,
                      items: _dropDownMenuItems,
                      onChanged: changedDropDownItems,
                    ),
                  ],
                ),
                DateTimeField(
                  controller: birthdayController,
                  decoration: InputDecoration(labelText: 'Fecha Nacimiento'),
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
                  },
                ),

                /*MultiSelectFormField(
                  autovalidate: false,
                  title: Text(''),
                  validator: (value) {
                    if (value == null || value.legth == 0) {
                      return 'Please select one or more options';
                    }
                  },
                  dataSource: _datos,
                  textField: 'display',
                  valueField: 'value',
                  okButtonLabel: 'OK',
                  cancelButtonLabel: 'CANCEL',
                  hintWidget: Text('Please choose one or more'),
                ),
                */
                RaisedButton(
                  child: Text('Add new User'),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      print(
                          contra() + "------------>" + birthdayController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }

  void changedDropDownItems(String charge) {
    setState(() {
      _currentCharge = charge;
    });
  }

  String contra() {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    int largoContra = 15;
    return String.fromCharCodes(Iterable.generate(
        largoContra, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }
}
