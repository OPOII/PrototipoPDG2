import 'package:flutter/material.dart';
import 'package:respaldo/src/pages/suerte/suerte.dart';
import 'package:respaldo/src/pages/suerte/suerteView.dart';

class ListadoSuerte extends StatelessWidget {
  final List<Suerte> listadoSuertes;
  ListadoSuerte({Key key, this.listadoSuertes}) : super(key: key);
  Icon usIcon = Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green[400]),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Buscar Suerte",
          style: TextStyle(color: Colors.green[400]),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'search',
            icon: usIcon,
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: SuerteSearch(listado: listadoSuertes));
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          listadoSuerte(context),
        ],
      ),
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

  Widget listadoSuerte(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: listadoSuertes.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              child: Card(
                elevation: 0.5,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SuerteView(suerte: listadoSuertes[index])));
                  },
                  title: Text("ID suerte: " + listadoSuertes[index].idSuerte),
                  leading: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/suerte/caña-azucar.jpg'),
                  ),
                  subtitle:
                      Text("Area perteneciente: " + listadoSuertes[index].area),
                ),
              ),
            );
          }),
    );
  }
}

class SuerteSearch extends SearchDelegate<Suerte> {
  List<Suerte> listado;
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
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final myList = query.isEmpty
        ? listado
        : listado
            .where((p) => p.idSuerte.toString().startsWith(query))
            .toList();
    return myList.isEmpty
        ? Text(
            'No results found...',
            style: TextStyle(fontSize: 20),
          )
        : ListView.builder(
            itemCount: myList.length,
            itemBuilder: (context, index) {
              final Suerte nuevoListado = myList[index];
              return ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SuerteView(suerte: listado[index])));
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID Suerte: ' + nuevoListado.idSuerte,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Area Suerte: ' + nuevoListado.area,
                      style: TextStyle(fontSize: 20),
                    ),
                    Divider()
                  ],
                ),
              );
            });
  }
}
