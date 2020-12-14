import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:respaldo/src/pages/suerte/suerteView.dart';
import 'package:respaldo/src/services/crud.dart';

import '../loading.dart';

// ignore: must_be_immutable
class ListadoSuerte extends StatelessWidget {
  final QueryDocumentSnapshot listadoSuertes;
  ListadoSuerte({Key key, this.listadoSuertes}) : super(key: key);
  CrudConsultas consultas = new CrudConsultas();
  Icon usIcon = Icon(Icons.search);
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SearchPages(listadoSuertes.id)));
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

class SearchPages extends StatefulWidget {
  final String id;
  SearchPages(this.id);
  @override
  State<StatefulWidget> createState() {
    return _SearchPageSuerte();
  }
}

class _SearchPageSuerte extends State<SearchPages> {
  String idDoc;
  @override
  void initState() {
    idDoc = widget.id;
    super.initState();
  }

  TextEditingController search = TextEditingController();
  final database = FirebaseFirestore.instance;
  String searchString;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          'Busca tu suerte',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        child: TextField(
                      onChanged: (val) {
                        setState(() {
                          searchString = val.toLowerCase();
                        });
                      },
                      controller: search,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () => search.clear()),
                        hintText: 'Search the suerte',
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Antra',
                            fontSize: 20),
                      ),
                    ))),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: (searchString == null || searchString.trim() == '')
                        ? FirebaseFirestore.instance
                            .collection('Ingenio')
                            .doc('1')
                            .collection('Hacienda')
                            .doc(idDoc)
                            .collection('Suerte')
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('Ingenio')
                            .doc('1')
                            .collection('Hacienda')
                            .doc(idDoc)
                            .collection('Suerte')
                            .where('searchIndex', arrayContains: searchString)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('We got an error ${snapshot.error}');
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Loading();
                        case ConnectionState.none:
                          return Text('There is no data');
                        case ConnectionState.done:
                          return Text('Done');
                        default:
                          return new ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot document) {
                              return new ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SuerteView(
                                                suerte: document,
                                              )));
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'ID suerte: ' + document['id_suerte'],
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                        'Area suerte: ' +
                                            document['area'].toString(),
                                        style: TextStyle(color: Colors.grey)),
                                    Divider()
                                  ],
                                ),
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://www.teldeactualidad.com/userfiles/economia/2020/06/5621/AURI%20SAAVEDRA%20VISITA%20LA%20FINCA%20LA%20SUERTE.jpeg'),
                                    backgroundColor: Colors.transparent),
                              );
                            }).toList(),
                          );
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
