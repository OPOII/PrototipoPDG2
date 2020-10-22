import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'lobby.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: new BoxDecoration(color: Colors.white),
        //voy a construir un arbol con los widgets mas grandes
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 63),
              child: Image.asset('assets/imgs/logo.png'),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please enter an email';
                        }
                      },
                      onSaved: (input) => _email = input,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: TextFormField(
                      validator: (input) {
                        if (input.length < 6) {
                          return 'You have to enter at least 6 characters';
                        }
                      },
                      onSaved: (input) => _password = input,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90.0),
              child: RaisedButton(
                child: Text('Login'),
                onPressed: signIn,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async {
    final formState = _formKey.currentState;

    if (formState.validate()) {
      try {
        formState.save();
        UserCredential user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Lobby()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
