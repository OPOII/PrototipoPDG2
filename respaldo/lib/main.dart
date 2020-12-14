import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:respaldo/src/pages/hacienda/haciendaView.dart';
import 'package:respaldo/src/pages/lobby.dart';
import 'package:respaldo/src/pages/loginPage.dart';
import 'package:respaldo/src/providers/push_notifications_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    final provider = new PushNotificationProvider();
    provider.initNotifications();

    provider.mensajes.listen((argumento) {
      print('Argumento del push');
      print(argumento);
    });
  }

  @override
  Widget build(BuildContext context) {
    //  return StreamProvider<Usuario>.value(
    //  value: AuthenticationService().user,
    return MaterialApp(
        title: 'Proyecto de grado',
        theme:
            ThemeData(textTheme: TextTheme(subtitle1: TextStyle(fontSize: 18))),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => LoginPage(),
          '/Lobby': (BuildContext context) => Lobby(),
          '/HaciendaView': (BuildContext context) => HaciendaView(),
        });
  }
}
