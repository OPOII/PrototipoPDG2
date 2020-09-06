import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  //Simplifico la forma de crear el padding para encapsular el texto
  Widget createEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 47),
      child: TextFormField(
        decoration: InputDecoration(hintText: 'Insert your username'),
      ),
    );
  }

  //Simplifico la forma de crear el padding para encapsular el texto
  Widget createPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 61),
      child: TextFormField(
        decoration: InputDecoration(hintText: 'Insert your password'),
        obscureText: true,
      ),
    );
  }

  Widget createLoginButton(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 50),
        child: RaisedButton(
          child: Text('Sing in'),
          onPressed: () {
            Navigator.pushNamed(context, '/Mapas');
          },
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
        ));
  }

  Widget forgotPassword() {
    return Container(
      padding: EdgeInsets.only(top: 32),
      child: Text(
        'Forgot your password?',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  //Widget crearDatos() {
  // return FutureBuilder(
  //  future: menuProvider.cargarData(),
  // initialData: [],
  //builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
  // return build(context);
  //},
  //);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: new BoxDecoration(color: Colors.white),
        //voy a construir un arbol con los widgets mas grandes
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(top: 63),
            child: Image.asset(
              'assets/imgs/logo.png',
              height: 300,
            ),
          ),
          createEmailInput(),
          createPasswordInput(),
          createLoginButton(context),
          forgotPassword(),
        ]),
      ),
    );
  }
}
