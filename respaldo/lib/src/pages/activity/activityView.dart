import 'package:flutter/material.dart';
import 'package:respaldo/src/services/crud.dart';

class ActividadReview extends StatefulWidget {
  final dynamic activity;

  ActividadReview({Key key, this.activity}) : super(key: key);
  @override
  _ReviewActivity createState() => _ReviewActivity(activity);
}

class _ReviewActivity extends State<ActividadReview> {
  final dynamic activ;
  dynamic datos;
  CrudConsultas consultas = new CrudConsultas();
  _ReviewActivity(this.activ);
  @override
  void initState() {
    super.initState();
  }

  void traerDatos() async {
    datos = await consultas.obtenerSuerteActual(
        activ['Clave_Hacienda'], activ['Clave_Suerte']);
    print(datos);
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
          activ['Nombre_Actividad'],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/imgs/fondo.jpg"),
                        fit: BoxFit.cover)),
                height: 200,
                child: Align(
                    alignment: Alignment.center,
                    child: ProfilePic(actividad: activ))),
            SizedBox(
              height: 20,
            ),
            ActivityMenu(
              text: activ['Nombre_Hacienda'],
              icon: Icons.home_work,
              press: () => {},
            ),
            ActivityMenu(
              text: activ['Nombre_Suerte'],
              icon: Icons.grass,
              press: () => {},
            ),
            ActivityMenu(
              text:
                  "Horas Programadas: " + activ['Horas_Programadas'].toString(),
              icon: Icons.access_time,
              press: () => {},
            ),
            ActivityMenu(
              text: "Horas Hechas: " + activ['Horas_Hechas'].toString(),
              icon: Icons.alarm,
              press: () => {},
            ),
            ActivityMenu(
              text: "Horas Faltantes: " + activ['Horas_Faltantes'].toString(),
              icon: Icons.timer,
              press: () => {},
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  final dynamic actividad;
  ProfilePic({Key key, this.actividad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://www.teldeactualidad.com/userfiles/economia/2020/06/5621/AURI%20SAAVEDRA%20VISITA%20LA%20FINCA%20LA%20SUERTE.jpeg'),
              backgroundColor: Colors.transparent),
        ],
      ),
    );
  }
}

class ActivityMenu extends StatelessWidget {
  const ActivityMenu({
    Key key,
    @required this.text,
    @required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: FlatButton(
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.transparent,
        onPressed: null,
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}
