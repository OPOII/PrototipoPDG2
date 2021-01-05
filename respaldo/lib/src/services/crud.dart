import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:respaldo/authentication_service.dart';

class CrudConsultas {
  AuthenticationService service = new AuthenticationService();
  String suerteID = "";
  String idUsuario = "";
  final CollectionReference lista = FirebaseFirestore.instance
      .collection('Ingenio')
      .doc('1')
      .collection('Hacienda');
  // Streams para el StreamBuilder
  Stream get haciendas {
    Stream aux = null;
    aux = FirebaseFirestore.instance
        .collection('Ingenio')
        .doc('1')
        .collection('Hacienda')
        .snapshots();
    return aux;
  }

  Future obtenerListaHaciendas() async {
    List haciendas = [];
    DocumentSnapshot ref = await FirebaseFirestore.instance
        .collection('Ingenio')
        .doc('1')
        .collection('users')
        .doc(service.uid)
        .get();
    if (ref.data()['charge'] == 'admin') {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('Hacienda')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          haciendas.add(element);
        });
      }).whenComplete(() => {print('Termino')});
      print(haciendas.length.toString() + "En el crud");
    } else if (ref.data()['charge'] == 'user') {
      List<dynamic> group = ref.get("haciendasResponsables");
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('Hacienda')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if (group.contains(element.data()['hacienda_name'])) {
            haciendas.add(element);
          }
        });
      });
    }
    print(haciendas.length.toString() +
        " Estas son las haciendas en su documento");
    return haciendas;
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

  //Consultas
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

  Future obtenerListadoHaciendas() async {
    List haciendas = [];
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('Hacienda')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          haciendas.add(element);
        });
      });
      print(haciendas.length.toString() + "En el crud");
      return haciendas;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future obtenerListadoSuertes(String id) async {
    print(id + "En el crud");
    List haciendas = [];
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('Hacienda')
          .doc(id)
          .collection('Suerte')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          haciendas.add(element);
        });
      });
      print(haciendas.length);
      return haciendas;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future obtenerListadoUsuarios() async {
    List usuarios = [];
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('users')
          .where("charge", isEqualTo: "user")
          .get()
          .then((value) {
        value.docs.forEach((element) {
          usuarios.add(element);
        });
      });
      return usuarios;
    } catch (e) {}
  }

  Future<String> obtenerIdUsuario(String nombre) async {
    String idUsuario = "";
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('users')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if (element.data()['name'] == nombre) {
            idUsuario = element.data()['id_user'];
            print(element.data()['Token_ID'] +
                "En el crud de obtener ID usuario");
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }
    print(idUsuario);
    return idUsuario;
  }

  Future<String> obtenerIDHacienda(String nombreHacienda) async {
    String idHacienda = "";
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('Hacienda')
          .where("hacienda_name", isEqualTo: nombreHacienda)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          idHacienda = element.data()['clave_hacienda'];
        });
      });
      return idHacienda;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> obtenerIDSuerte(String nombreSuerte, String idHacienda) async {
    String idSuerte = "";
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('Hacienda')
          .doc(idHacienda)
          .collection('Suerte')
          .where("id_suerte", isEqualTo: nombreSuerte)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          idSuerte = element.data()['claveSuerte'];
          suerteID = element.data()['claveSuerte'];
        });
      });
      return idSuerte;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future obtenerListadoTareasActualUser(String id) async {
    List tareas = [];
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('users')
          .doc(id)
          .collection('tareas')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          tareas.add(element);
        });
      });
      return tareas;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future obtenerSuerteActual(String hacienda, String suerte) async {
    dynamic suerte;
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('Hacineda')
          .doc(hacienda)
          .collection('Suerte')
          .doc(suerte)
          .get()
          .then((value) {
        suerte = value;
      });
      return suerte;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
