import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:respaldo/authentication_service.dart';

class CrudConsultas {
  final CollectionReference lista = FirebaseFirestore.instance
      .collection('Ingenio')
      .doc('1')
      .collection('Hacienda');

  //
  Future getEmpleadoActual(String idActual) async {
    print(idActual);
    List usuario = [];
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('users')
          .get()
          .then((querysnapshot) {
        querysnapshot.docs.forEach((element) {
          if (element.id == idActual) {
            usuario.add(element);
          }
        });
      });
      return usuario;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//
  Stream get haciendas {
    Stream aux = null;
    AuthenticationService actual = new AuthenticationService();
    String cargo;
    Future<DocumentSnapshot> n = FirebaseFirestore.instance
        .collection('Ingenio')
        .doc('1')
        .collection('users')
        .doc(actual.currentUser.uid)
        .get();
    n.then((value) {
      cargo = value.data()['charge'];
      print(cargo);
    });
    aux = FirebaseFirestore.instance
        .collection('Ingenio')
        .doc('1')
        .collection('Hacienda')
        .snapshots();
    return aux;
  }

//
  Stream obtenerSuertes(String idHacienda) {
    return FirebaseFirestore.instance
        .collection('Ingenio')
        .doc('1')
        .collection('Hacienda')
        .doc(idHacienda)
        .collection('Suerte')
        .snapshots();
  }
}
