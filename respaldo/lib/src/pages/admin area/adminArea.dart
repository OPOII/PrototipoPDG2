import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'agregarTareas.dart';
import 'agregarUsuarios.dart';

class AdminArea extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AreaAdmins();
}

class _AreaAdmins extends State<AdminArea> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text(
          "Area de administradores",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Grids(),
      ),
    );
  }
}

class Grids extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GridsState();
}

class _GridsState extends State<Grids> {
  final grids = [
    {
      "titulo": "Agregar usuarios",
      "imagen": "assets/imgs/adduser.png",
    },
    {
      "titulo": "Agregar tareas",
      "imagen": "assets/imgs/addtask.png",
    },
    {
      "titulo": "Ver tareas",
      "imagen": "assets/imgs/viewtask.png",
    },
    {
      "titulo": "Ver usuarios",
      "imagen": "assets/imgs/viewuser.png",
    }
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: grids.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Cards(
            name: grids[index]['titulo'],
            url: grids[index]['imagen'],
          );
        });
  }
}

class Cards extends StatelessWidget {
  final name;
  final url;
  Cards({this.name, this.url});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
          tag: name,
          child: Material(
            child: InkWell(
              onTap: () => {
                if (name == "Agregar usuarios")
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AgregarUsuarios()))
                  }
                else if (name == "Agregar tareas")
                  {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TareaView(title: 'Agregar Tarea')))
                  }
                else if (name == "Ver usuarios")
                  {print("opcion 3")}
                else if (name == "Ver tareas")
                  {print("opcion 4")}
              },
              child: GridTile(
                footer: Container(
                  color: Colors.black12,
                  child: ListTile(
                    leading: Text(
                      name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ),
                child: Image.asset(
                  url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )),
    );
  }
}
