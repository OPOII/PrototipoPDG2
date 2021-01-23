class Tarea {
  // ignore: non_constant_identifier_names
  String hdaste;
  String area; //doublle
  String corte; //int
  String edad; //double
  String nombreActividad;
  String grupo;
  String distrito;
  String tipoCultivo;
  String nombreHacienda;
  String fecha; //DateTime
  String hacienda; //int
  String suerte;
  String programa; //double
  String actividad; //int
  String ejecutable; //double
  String pendiente; //double
  String observacion;
  String encargado;
  Tarea(
      {this.hdaste,
      this.area,
      this.corte,
      this.edad,
      this.nombreActividad,
      this.grupo,
      this.distrito,
      this.tipoCultivo,
      this.nombreHacienda,
      this.fecha,
      this.hacienda,
      this.suerte,
      this.programa,
      this.actividad,
      this.ejecutable,
      this.pendiente,
      this.observacion,
      this.encargado});
  factory Tarea.fromJson(dynamic json) {
    return Tarea(
      hdaste: "${json['hdaste']}",
      area: "${json['area']}",
      corte: "${json['corte']}",
      edad: "${json['edad']}",
      nombreActividad: "${json['nombreActividad']}",
      grupo: "${json['grupo']}",
      distrito: "${json['distrito']}",
      tipoCultivo: "${json['tipoCultivo']}",
      nombreHacienda: "${json['nombreHacienda']}",
      fecha: "${json['fecha']}",
      hacienda: "${json['hacienda']}",
      suerte: "${json['suerte']}",
      programa: "${json['programa']}",
      actividad: "${json['actividad']}",
      ejecutable: "${json['ejecutable']}",
      pendiente: "${json['pendiente']}",
      observacion: "${json['observacion']}",
      encargado: "${json['encargado']}",
    );
  }

  // Method to make GET parameters.
  Map toJson() => {
        'hdaste': hdaste,
        'area': area,
        'corte': corte,
        'edad': edad,
        'nombreActividad': nombreActividad,
        'grupo': grupo,
        'distrito': distrito,
        'tipoCultivo': tipoCultivo,
        'nombreHacienda': nombreHacienda,
        'fecha': fecha,
        'hacienda': hacienda,
        'suerte': suerte,
        'programa': programa,
        'actividad': actividad,
        'ejecutable': ejecutable,
        'pendiente': pendiente,
        'observacion': observacion,
        'encargado': encargado
      };
  Map<String, dynamic> toMap() {
    return {
      "hdaste": hdaste,
      "area": area,
      "corte": corte,
      "edad": edad,
      "nombreActividad": nombreActividad,
      "grupo": grupo,
      "distrito": distrito,
      "tipoCultivo": tipoCultivo,
      "nombreHacienda": nombreHacienda,
      "fecha": fecha,
      "hacienda": hacienda,
      "suerte": suerte,
      "programa": programa,
      "actividad": actividad,
      "ejecutable": ejecutable,
      "pendiente": pendiente,
      "observacion": observacion,
      "encargado": encargado
    };
  }

  Tarea.fromMap(Map<String, dynamic> map) {
    hdaste = map['name'];
    area = map['area']; //doublle
    corte = map['corte']; //int
    edad = map['edad']; //double
    nombreActividad = map['nombreActividad'];
    grupo = map['grupo'];
    distrito = map['distrito'];
    tipoCultivo = map['tipoCultivo'];
    nombreHacienda = map['nombreHacienda'];
    fecha = map['fecha']; //DateTime
    hacienda = map['hacienda']; //int
    suerte = map['suerte'];
    programa = map['programa']; //double
    actividad = map['actividad']; //int
    ejecutable = map['ejecutable']; //double
    pendiente = map['pendiente']; //double
    observacion = map['observacion'];
    encargado = map['encargado'];
  }
}
