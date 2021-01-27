import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:respaldo/src/DatabaseView.dart';
import 'package:respaldo/src/pages/user/userView.dart';
import 'package:respaldo/src/services/crud.dart';

class Allusers extends StatefulWidget {
  @override
  _AllusersState createState() => _AllusersState();
}

class _AllusersState extends State<Allusers> {
  List usuarios = [];
  CrudConsultas consultas = new CrudConsultas();
  ConnectivityResult oldres;
  StreamSubscription connectivityStream;
  bool dialogshown = false;
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
    obtenerUsuarios();
  }

  @override
  void dispose() {
    super.dispose();
    connectivityStream.cancel();
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
            return FadeInLeft(
              delay: Duration(milliseconds: 100 * index),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              UserView(user: usuarios[index])));
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
              ),
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
