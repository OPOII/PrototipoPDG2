import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:respaldo/src/pages/user/userView.dart';
import 'package:respaldo/src/services/crud.dart';

class Allusers extends StatefulWidget {
  @override
  _AllusersState createState() => _AllusersState();
}

class _AllusersState extends State<Allusers> {
  List usuarios = [];
  CrudConsultas consultas = new CrudConsultas();
  @override
  void initState() {
    super.initState();
    obtenerUsuarios();
  }

  void obtenerUsuarios() async {
    dynamic resultado = await consultas.obtenerListadoUsuarios();
    setState(() {
      usuarios = resultado;
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
          "Todos los usuarios",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'search',
            icon: Icon(Icons.person_search),
            onPressed: () {
              showSearch(
                  context: context, delegate: UsuarioSearch(listado: usuarios));
            },
          )
        ],
      ),
      body: ListView.builder(
          itemCount: usuarios.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserView(user: usuarios[index])));
              },
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Nombre: ' + usuarios[index]['name'],
                    style: TextStyle(fontSize: 20),
                  ),
                  Text('Cedula: ' + usuarios[index]['cedula'].toString(),
                      style: TextStyle(color: Colors.grey)),
                  Divider()
                ],
              ),
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(usuarios[index]['urlfoto']),
                  backgroundColor: Colors.transparent),
            );
          }),
    );
  }
}

//Este widget puede ser reciclado, tomar en cuenta
class UsuarioSearch extends SearchDelegate<dynamic> {
  List listado;
  UsuarioSearch({this.listado});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List myList = query.isEmpty
        ? listado
        : listado
            .where((p) => p['cedula'].toString().startsWith(query))
            .toList();
    return myList.isEmpty
        ? Text(
            'No resoults found...',
            style: TextStyle(fontSize: 20),
          )
        : ListView.builder(
            itemCount: myList
                .length, //Aqui esta el problema, si lo pongo listado.length.compareTo(0) entonces solo me deja ver el primer elemento => update, el error era que le estaba pasando el "listado" en vez de "myList"
            itemBuilder: (context, index) {
              QueryDocumentSnapshot nuevoListado = myList[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserView(user: nuevoListado)));
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      nuevoListado['name'],
                      style: TextStyle(fontSize: 20),
                    ),
                    Text('Cedula Usuario: ' + nuevoListado['cedula'].toString(),
                        style: TextStyle(color: Colors.grey)),
                    Divider()
                  ],
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(nuevoListado['urlfoto']),
                ),
              );
            });
  }
}
