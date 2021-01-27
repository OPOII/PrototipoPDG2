import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:respaldo/src/DatabaseView.dart';
import 'package:respaldo/src/pages/suerte/suerteView.dart';
import 'package:respaldo/src/services/crud.dart';

import '../loading.dart';

class ListadoSuerte extends StatefulWidget {
  final QueryDocumentSnapshot listadoSuertes;
  ListadoSuerte({Key key, this.listadoSuertes}) : super(key: key);
  @override
  _ListadoSuerte createState() => _ListadoSuerte(listadoSuertes);
}

class _ListadoSuerte extends State<ListadoSuerte> {
  final QueryDocumentSnapshot listadoSuertes;
  _ListadoSuerte(this.listadoSuertes);
  CrudConsultas consultas = new CrudConsultas();
  Icon usIcon = Icon(Icons.search);
  List suertesListado = [];
  ConnectivityResult oldres;
  StreamSubscription connectivityStream;
  bool dialogshown = false;
  // ignore: missing_return
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
    obtenerListado();
  }

  @override
  void dispose() {
    super.dispose();
    connectivityStream.cancel();
  }

  void obtenerListado() async {
    dynamic listado = await consultas.obtenerListadoSuertes(listadoSuertes.id);
    setState(() {
      suertesListado = listado;
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream suertes = consultas.obtenerSuertes(listadoSuertes.id);
    return StreamBuilder<QuerySnapshot>(
      stream: suertes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error ${snapshot.error}'),
          );
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Loading();
          case ConnectionState.none:
            return Text('There is no data');
          case ConnectionState.done:
            return Text('Done');
          default:
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                elevation: 0,
                backgroundColor: Colors.green,
                centerTitle: true,
                title: Text(
                  "Buscar Suerte",
                  style: TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  IconButton(
                    tooltip: 'search',
                    icon: usIcon,
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: SuerteSearch(listado: suertesListado));
                    },
                  )
                ],
              ),
              body: Card(
                elevation: 0.5,
                child: new ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return new ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SuerteView(suerte: document)));
                      },
                      title: Text('ID suerte: ' + document['id_suerte']),
                      leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://www.teldeactualidad.com/userfiles/economia/2020/06/5621/AURI%20SAAVEDRA%20VISITA%20LA%20FINCA%20LA%20SUERTE.jpeg'),
                          backgroundColor: Colors.transparent),
                      subtitle: Text(
                          'Area perteneciente: ' + document['area'].toString()),
                    );
                  }).toList(),
                ),
              ),
            );
        }
      },
    );
  }

  Widget contenedor() {
    return Container(
      color: Colors.white,
      child: new AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: new TextField(
          // controller: _searchQuery,
          style: new TextStyle(color: Colors.black),
          decoration: new InputDecoration(
              border: new OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(30.0),
                ),
              ),
              filled: false,
              prefixIcon: new Icon(
                Icons.search,
                color: Colors.green,
              ),
              hintText: "Search...",
              hintStyle: new TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}

class SuerteSearch extends SearchDelegate<dynamic> {
  List listado;
  SuerteSearch({this.listado});

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
    print(listado.length.toString());
    List myList = query.isEmpty
        ? listado
        : listado
            .where((p) => p['id_suerte'].toString().startsWith(query))
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
                          builder: (context) => SuerteView(
                                suerte: nuevoListado,
                              )));
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Area de la suerte: ' + nuevoListado['area'].toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                    Text('Id suerte: ' + nuevoListado['id_suerte'].toString(),
                        style: TextStyle(color: Colors.grey)),
                    Divider()
                  ],
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://www.teldeactualidad.com/userfiles/economia/2020/06/5621/AURI%20SAAVEDRA%20VISITA%20LA%20FINCA%20LA%20SUERTE.jpeg'),
                ),
              );
            });
  }
}
