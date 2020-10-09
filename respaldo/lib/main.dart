import 'package:flutter/material.dart';
import 'package:respaldo/src/pages/balancePage.dart';
import 'package:respaldo/src/pages/hacienda/haciendaView.dart';
import 'package:respaldo/src/pages/hacienda/lobbyHaciendas.dart';
import 'package:respaldo/src/pages/lobby.dart';
import 'package:respaldo/src/pages/loginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto de grado',
      theme:
          ThemeData(textTheme: TextTheme(subtitle1: TextStyle(fontSize: 18))),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => LoginPage(),
        '/Mapas': (BuildContext context) => Lobby(),
        '/BalanceHidrico': (BuildContext context) => BalanceHidrico(),
        '/HaciendaView': (BuildContext context) => HaciendaView(),
        '/ListadoHaciendas': (BuildContext context) => ListadoHacienda(),
      },
    );
    //    home: LoginPage());
  }
}
