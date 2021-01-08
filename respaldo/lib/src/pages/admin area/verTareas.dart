import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    obtenerHaciendas();
    obtenerUsuarios();
    currentHacienda = "";
    currentSuerte = "";
    currentUser = "";
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
    //Buscar por los tres
    else if (hacienda != "" && suerte != "" && usuario != "") {
      dynamic resultado = await consultas.buscarPorHaciendaSuerteUsuario(
          hacienda, suerte, usuario);
      setState(() {
        tareas = resultado;
      });
    } else if (hacienda == "" && suerte == "" && usuario == "") {
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Center(
                  child:
                      Text('Filtrar Busqueda', style: TextStyle(fontSize: 20)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Filtrar por haciendas",
                        style: TextStyle(fontSize: 15)),
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
                    Text("Filtrar por suertes", style: TextStyle(fontSize: 15)),
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
                  onPressed: () {},
                ),
              ],
            ),
          ),
          listadoFiltradoTareas(context, tareas),
        ],
      ),
    );
  }
}

Widget listadoFiltradoTareas(BuildContext context, List tareas) {
  return tareas.isEmpty
      ? Container(
          child: Text('Hi'),
          color: Colors.blue,
        )
      : ListView.builder(
          itemCount: 5,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Hacienda:'),
                  SizedBox(height: 2.0),
                  Text('Suerte:'),
                  SizedBox(height: 2.0),
                  Text('Encargado:'),
                  SizedBox(height: 2.0),
                ],
              ),
            );
          });
}
