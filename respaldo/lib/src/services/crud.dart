import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:respaldo/authentication_service.dart';
import 'package:respaldo/src/pages/Database.dart';
import 'package:respaldo/src/pages/tarea/tarea.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:convert';

class CrudConsultas {
  static final coleccionBasesDatos = "repositorio";
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
      }).whenComplete(() => {});
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
    return haciendas;
  }
  /**
   * Este es el insumo del lunes en que el administrador cargara el listado de excel
   */

  insumoDiaLunesAdmin() async {
    var raw = await http.get(
        "https://script.google.com/macros/s/AKfycbx_7Zv5RIidsvtufVEmuQeSycC8PZ_A3O6tmhaHj5WMOBMrucLx/exec");
    var jsonFeedback = convert.jsonDecode(raw.body);

    jsonFeedback.forEach(
      (element) async {
        await FirebaseFirestore.instance
            .collection('Ingenio')
            .doc('1')
            .collection(coleccionBasesDatos)
            .doc(element['id'].toString())
            .set(element);
      },
    );
  }

  Future<List<Tarea>> traerInsumoDeFirebase() async {
    List<Tarea> listado = List<Tarea>();
    await FirebaseFirestore.instance
        .collection('Ingenio')
        .doc('1')
        .collection(coleccionBasesDatos)
        .get()
        .then(
      (value) {
        value.docs.forEach(
          (element) {
            Tarea actual = new Tarea();
            actual.hdaste = element['hdaste'].toString();
            actual.area = element['area'].toString();
            actual.corte = element['corte'].toString();
            actual.edad = element['edad'].toString();
            actual.nombreActividad = element['nombre_actividad'].toString();
            actual.grupo = element['grupo'].toString();
            actual.distrito = element['distrito'].toString();
            actual.tipoCultivo = element['tipo_cultivo'].toString();
            actual.nombreHacienda = element['nombre_hacienda'].toString();
            actual.fecha = element['fecha'].toString();
            actual.hacienda = element['hacienda'].toString();
            actual.suerte = element['suerte'].toString();
            actual.programa = element['horas_programadas'].toString();
            actual.actividad = element['actividad'].toString();
            actual.ejecutable = element['ejecutable'].toString();
            actual.pendiente = element['pendiente'].toString();
            actual.observacion = element['observacion'].toString();
            actual.encargado = element['encargado'].toString();
            actual.id = element['id'];
            print(actual.toJson());
            listado.add(actual);
          },
        );
      },
    );
    return Future.value(listado);
  }

  Future<List<Tarea>> extraerInfoExcel() async {
    DocumentSnapshot referencia = await FirebaseFirestore.instance
        .collection('Ingenio')
        .doc('1')
        .collection('users')
        .doc(service.uid)
        .get();
    List<Tarea> listados = List<Tarea>();
    var raw = await http.get(
        "https://script.google.com/macros/s/AKfycbx_7Zv5RIidsvtufVEmuQeSycC8PZ_A3O6tmhaHj5WMOBMrucLx/exec");
    var jsonFeedback = convert.jsonDecode(raw.body);
    jsonFeedback.forEach(
      (element) async {
        if (referencia.data()['charge'] == 'user' &&
            referencia.data()['codigo_hacienda'].toString() ==
                element['hacienda'].toString() &&
            referencia.data()['identificacion'].toString() ==
                element['encargado']) {
          Tarea actual = new Tarea();
          actual.hdaste = element['hdaste'].toString();
          actual.area = element['area'].toString();
          actual.corte = element['corte'].toString();
          actual.edad = element['edad'].toString();
          actual.nombreActividad = element['nombre_actividad'].toString();
          actual.grupo = element['grupo'].toString();
          actual.distrito = element['distrito'].toString();
          actual.tipoCultivo = element['tipo_cultivo'].toString();
          actual.nombreHacienda = element['nombre_hacienda'].toString();
          actual.fecha = element['fecha'].toString();
          actual.hacienda = element['hacienda'].toString();
          actual.suerte = element['suerte'].toString();
          actual.programa = element['horas_programadas'].toString();
          actual.actividad = element['actividad'].toString();
          actual.ejecutable = element['ejecutable'].toString();
          actual.pendiente = element['pendiente'].toString();
          actual.observacion = element['observacion'].toString();
          actual.encargado = element['encargado'].toString();
          actual.id = element['id'];
          listados.add(actual);
        }
      },
    );
    await DataBaseOffLine.instance.llenarTabla(listados);
    return Future.value(listados);
  }

  Future<List<Tarea>> devolvereDeConsultaSql() async {
    List<Tarea> tarea = List<Tarea>();
    tarea = await DataBaseOffLine.instance.queryAll();
    return tarea;
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
      return Future.value(usuario);
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

  Future buscarPorHacienda(String hacienda) async {
    List filtradoHacienda = [];
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('tasks')
          .where("Nombre_Hacienda", isEqualTo: hacienda)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          filtradoHacienda.add(element);
        });
      });
      return filtradoHacienda;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future buscarPorHaciendaSuerte(String hacienda, String suerte) async {
    List filtradoHaciendaSuerte = [];
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('tasks')
          .where("Nombre_Hacienda", isEqualTo: hacienda)
          .where("Nombre_Suerte", isEqualTo: suerte)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          filtradoHaciendaSuerte.add(element);
        });
      });
      return filtradoHaciendaSuerte;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future buscarPorHaciendaUsuario(String hacienda, String usuario) async {
    List filtradoHaciendaSuerte = [];
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('tasks')
          .where("Nombre_Hacienda", isEqualTo: hacienda)
          .where("Usuario_Encargado", isEqualTo: usuario)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          filtradoHaciendaSuerte.add(element);
        });
      });
      return filtradoHaciendaSuerte;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future buscarPorHaciendaSuerteUsuario(
      String hacienda, String suerte, String usuario) async {
    List filtradoHaciendaSuerteUsuario = [];
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('tasks')
          .where("Nombre_Hacienda", isEqualTo: hacienda)
          .where("Nombre_Suerte", isEqualTo: suerte)
          .where("Usuario_Encargado", isEqualTo: usuario)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          filtradoHaciendaSuerteUsuario.add(element);
        });
      });
      return filtradoHaciendaSuerteUsuario;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future traerTodasLasTareas() async {
    List tareas = [];
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('tasks')
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

  Future buscarPorUsuario(String usuario) async {
    List filtradoUsuarios = [];
    try {
      await FirebaseFirestore.instance
          .collection('Ingenio')
          .doc('1')
          .collection('tasks')
          .where("Usuario_Encargado", isEqualTo: usuario)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          filtradoUsuarios.add(element);
        });
      });
      return filtradoUsuarios;
    } catch (e) {
      print(e.toString());
      return null;
    }
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
