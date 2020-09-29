import 'package:flutter/material.dart';
import 'package:respaldo/src/pages/suerte/suerte.dart';
import 'package:respaldo/src/pages/suerte/suerteView.dart';

class ListadoSuerte extends StatelessWidget {
  final List<Suerte> listadoSuertes;
  ListadoSuerte({Key key, this.listadoSuertes}) : super(key: key);
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
      ),
      body: Stack(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 0), child: contenedor()),
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: listadoSuerte(context),
          )
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.8),
        child: Container(
          color: Colors.white,
          height: 0.75,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Buscar Suerte',
        style: TextStyle(color: Colors.green[400]),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.green[400],
        onPressed: () {
          Navigator.pushNamed(context, "/HaciendaView");
        },
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
                color: Colors.green,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SuerteView(suerte: listadoSuertes[index])));
                  },
                  title: Text(listadoSuertes[index].idSuerte),
                  leading: CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/suerte/caña-azucar.jpg'),
                  ),
                  subtitle: Text(listadoSuertes[index].area),
                ),
              ),
            );
          }),
    );
  }
}
