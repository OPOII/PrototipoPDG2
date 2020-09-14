import 'package:flutter/material.dart';

class ListadoHacienda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: _appBar(context),
      body: Stack(
        children: <Widget>[contenedor()],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.5),
        child: Container(
          color: Color(0xFFF9F9F9),
          height: 0.75,
        ),
      ),
      backgroundColor: Color(0xFFF9F9F9),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Buscar Hacienda',
        style: TextStyle(color: Colors.green[400]),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: Colors.green[400],
        onPressed: () {
          Navigator.pushNamed(context, '/Mapas');
        },
      ),
    );
  }

  Widget _etiquetas() {
    return Text('Body');
  }

  Widget contenedor() {
    return Container(
      height: 70,
      color: Colors.transparent,
      child: new AppBar(
        backgroundColor: Color(0xFFF9F9F9),
        automaticallyImplyLeading: false,
        title: new TextField(
          // controller: _searchQuery,
          style: new TextStyle(color: Colors.white),
          decoration: new InputDecoration(
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
