import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:respaldo/src/pages/hacienda/hacienda.dart';
import 'package:respaldo/src/pages/hacienda/haciendaView.dart';
import 'package:respaldo/src/pages/suerte/suerte.dart';

class ListadoHacienda extends StatelessWidget {
  List<Hacienda> miniListado;
  List<List<Suerte>> listadoSuertes;
  @override
  Widget build(BuildContext context) {
    cargarSuertes();
    miniListado = cargarHacienda();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Stack(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10), child: contenedor()),
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: listadoHaciendas(context),
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

  Widget listadoHaciendas(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: miniListado.length,
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
                                HaciendaView(hacienda: miniListado[index])));
                  },
                  title: Text(miniListado[index].nombre),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/haciendas/${miniListado[index].imagen}'),
                  ),
                  subtitle: Text(miniListado[index].ubicacion),
                ),
              ),
            );
          }),
    );
  }

  List<Hacienda> cargarHacienda() {
    List<Hacienda> listado = [
      new Hacienda(
          'INGENIO PICHICHI S.A',
          654654,
          listadoSuertes[0],
          "Cali, Valle del cauca",
          new LatLng(3.4719911, -76.519074),
          'ingenio_pichichi.jpeg',
          90,
          155),
      new Hacienda(
        'Ingenio Manuelita',
        5468,
        listadoSuertes[1],
        "Cali, Valle del cauca",
        new LatLng(3.4509319, -76.5393067),
        'ingenio_manuelita.jpeg',
        15,
        64,
      ),
      new Hacienda(
          'Ingenio Mayagüez',
          5468,
          listadoSuertes[2],
          "Candelaria, Valle del cauca",
          new LatLng(3.3991057, -76.3291369),
          'ingenio_mayaguez.jpg',
          55,
          77),
      new Hacienda(
          'Ingenio la Cabaña',
          5468,
          listadoSuertes[3],
          "Guachené, Caloto, Cauca",
          new LatLng(3.1807526, -76.3985681),
          'ingenio_la_cabaña.jpg',
          8,
          72),
      new Hacienda(
          'Ingenio Central Tumaco',
          5468,
          listadoSuertes[4],
          "Riofrío, Palmira, Valle del Cauca",
          new LatLng(3.5491588, -76.3303793),
          'ingenio_central_tumaco.jpg',
          28,
          35),
      new Hacienda('Asocaña', 5468, listadoSuertes[5], "Cali, Valle del cauca",
          new LatLng(3.4874398, -76.5122882), 'ingenio_asocaña.jpg', 92, 144),
    ];
    return listado;
  }

  void cargarSuertes() {
    listadoSuertes = new List<List<Suerte>>();
    List<Suerte> ingenioPichinchi = [
      new Suerte(alAzar(), 155, 29, area(), "5464849789", "Ingenio Pichinchi"),
      new Suerte(alAzar(), 88, 87, area(), "a5d4f6a4", "Ingenio Pichinchi"),
      new Suerte(alAzar(), 90, 14, area(), "sd656465", "Ingenio Pichinchi"),
      new Suerte(alAzar(), 101, 66, area(), "eafdagas", "Ingenio Pichinchi"),
      new Suerte(alAzar(), 77, 29, area(), "6545645", "Ingenio Pichinchi"),
      new Suerte(alAzar(), 197, 155, area(), "879465958", "Ingenio Pichinchi")
    ];
    listadoSuertes.add(ingenioPichinchi);
    List<Suerte> ingenioManuelita = [
      new Suerte(alAzar(), 155, 29, area(), "5464849789", "Ingenio Manuelita"),
      new Suerte(alAzar(), 88, 87, area(), "a5d4f6a4", "Ingenio Manuelita"),
      new Suerte(alAzar(), 90, 14, area(), "sd656465", "Ingenio Manuelita"),
      new Suerte(alAzar(), 101, 66, area(), "eafdagas", "Ingenio Manuelita"),
      new Suerte(alAzar(), 77, 29, area(), "6545645", "Ingenio Manuelita"),
      new Suerte(alAzar(), 197, 155, area(), "879465958", "Ingenio Manuelita")
    ];
    listadoSuertes.add(ingenioManuelita);
    List<Suerte> ingenioMayaguez = [
      new Suerte(alAzar(), 155, 29, area(), "5464849789", "Ingenio Mayaguez"),
      new Suerte(alAzar(), 88, 87, area(), "a5d4f6a4", "Ingenio Mayaguez"),
      new Suerte(alAzar(), 90, 14, area(), "sd656465", "Ingenio Mayaguez"),
      new Suerte(alAzar(), 101, 66, area(), "eafdagas", "Ingenio Mayaguez"),
      new Suerte(alAzar(), 77, 29, area(), "6545645", "Ingenio Mayaguez"),
      new Suerte(alAzar(), 197, 155, area(), "879465958", "Ingenio Mayaguez")
    ];
    listadoSuertes.add(ingenioMayaguez);
    List<Suerte> ingenioLaCabana = [
      new Suerte(alAzar(), 155, 29, area(), "5464849789", "Ingenio La Cabaña"),
      new Suerte(alAzar(), 88, 87, area(), "a5d4f6a4", "Ingenio La Cabaña"),
      new Suerte(alAzar(), 90, 14, area(), "sd656465", "Ingenio La Cabaña"),
      new Suerte(alAzar(), 101, 66, area(), "eafdagas", "Ingenio La Cabaña"),
      new Suerte(alAzar(), 77, 29, area(), "6545645", "Ingenio La Cabaña"),
      new Suerte(alAzar(), 197, 155, area(), "879465958", "Ingenio La Cabaña")
    ];
    listadoSuertes.add(ingenioLaCabana);
    List<Suerte> ingenioCentralTumaco = [
      new Suerte(
          alAzar(), 155, 29, area(), "5464849789", "Ingenio Central Tumaco"),
      new Suerte(
          alAzar(), 88, 87, area(), "a5d4f6a4", "Ingenio Central Tumaco"),
      new Suerte(
          alAzar(), 90, 14, area(), "sd656465", "Ingenio Central Tumaco"),
      new Suerte(
          alAzar(), 101, 66, area(), "eafdagas", "Ingenio Central Tumaco"),
      new Suerte(alAzar(), 77, 29, area(), "6545645", "Ingenio Central Tumaco"),
      new Suerte(
          alAzar(), 197, 155, area(), "879465958", "Ingenio Central Tumaco")
    ];
    listadoSuertes.add(ingenioCentralTumaco);
    List<Suerte> asocana = [
      new Suerte(alAzar(), 155, 29, area(), "5464849789", "Ingenio Asocaña"),
      new Suerte(alAzar(), 88, 87, area(), "a5d4f6a4", "Ingenio Asocaña"),
      new Suerte(alAzar(), 90, 14, area(), "sd656465", "Ingenio Asocaña"),
      new Suerte(alAzar(), 101, 66, area(), "eafdagas", "Ingenio Asocaña"),
      new Suerte(alAzar(), 77, 29, area(), "6545645", "Ingenio Asocaña"),
      new Suerte(alAzar(), 197, 155, area(), "879465958", "Ingenio Asocaña")
    ];
    listadoSuertes.add(asocana);
  }

  String alAzar() {
    Random random = new Random();
    List<String> id = ["ORIENTE", "NORTE", "SECTOR 2", "AZRF", "SST", "BBC"];
    int idint = random.nextInt(400);
    int sector = random.nextInt(id.length);
    String retorno = idint.toString() + " " + id[sector];
    return retorno;
  }

  String area() {
    List<String> id = ["ORIENTE", "NORTE", "SECTOR 2", "AZRF", "SST", "BBC"];
    Random n = new Random();
    int pos = n.nextInt(id.length);
    return id[pos];
  }
}
