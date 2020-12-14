import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:respaldo/databaseConnection.dart';
import 'package:respaldo/src/pages/loading.dart';
import 'package:respaldo/src/pages/networkAwareWidget.dart';
import 'package:respaldo/src/services/networkStatusService.dart';
import '../../authentication_service.dart';
import 'lobby.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  StreamSubscription connectivityStream;
  ConnectivityResult oldres;

  @override
  void initState() {
    super.initState();
    connectivityStream =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult resu) {
      oldres = resu;
    });
  }

  @override
  void dispose() {
    super.dispose();
    connectivityStream.cancel();
  }

  String email, password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthenticationService _authenticationService = AuthenticationService();
  final ConeccionBaseDatos baseDatos = ConeccionBaseDatos();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    // baseDatos.dataBaseConnection();
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: StreamProvider<NetworkStatus>(
              create: (context) =>
                  NetworkStatusService().networkStatusController.stream,
              child: NetworkAwareWidget(
                onlineChild: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: new BoxDecoration(color: Colors.white),
                    //voy a construir un arbol con los widgets mas grandes
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 63),
                          child: Image.asset('assets/imgs/logo.png'),
                        ),
                        SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: TextFormField(
                                    // ignore: missing_return
                                    validator: (input) {
                                      if (input.isEmpty) {
                                        return 'Please enter an email';
                                      }
                                    },
                                    onSaved: (input) => email = input,
                                    decoration:
                                        InputDecoration(labelText: 'Email'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: TextFormField(
                                    // ignore: missing_return
                                    validator: (input) {
                                      if (input.length < 6) {
                                        return 'You have to enter at least 6 characters';
                                      }
                                    },
                                    onSaved: (input) => password = input,
                                    decoration:
                                        InputDecoration(labelText: 'Password'),
                                    obscureText: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 90.0),
                          child: RaisedButton(
                            child: Text('Login'),
                            onPressed: () async {
                              final formState = _formKey.currentState;
                              if (formState.validate()) {
                                setState(() => loading = true);
                                formState.save();
                                dynamic result = await _authenticationService
                                    .signEmailPassword(email, password);
                                if (result == null) {
                                  loading = false;
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text('Usuario no valido'),
                                            content: Text(
                                                'El usuario con el que esta intentando acceder no se encuentra en nuestra base de datos, por favor ingrese con un usuario valido'),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          ));
                                } else if (_authenticationService.currentUser !=
                                    null) {
                                  print(_authenticationService.currentUser.uid);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      settings: RouteSettings(name: '/Lobby'),
                                      builder: (context) => Lobby()));
                                }
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                offlineChild: Container(
                  child: Center(
                    child: Text(
                      "No internet connection!",
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
