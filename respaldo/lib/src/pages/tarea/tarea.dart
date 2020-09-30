class Tarea {
  // ignore: non_constant_identifier_names
  String hdaSte;
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
  String horasProgramadas; //double
  String actividad; //int
  String horasEjecutadas; //double
  String pendiente; //double
  String observacion;
  Tarea(
      this.hdaSte,
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
      this.horasProgramadas,
      this.actividad,
      this.horasEjecutadas,
      this.pendiente,
      this.observacion);
  factory Tarea.fromJson(dynamic json) {
    return Tarea(
        "${json['hdaSte']}",
        "${json['area']}",
        "${json['corte']}",
        "${json['edad']}",
        "${json['nombreActividad']}",
        "${json['grupo']}",
        "${json['distrito']}",
        "${json['tipoCultivo']}",
        "${json['nombreHacienda']}",
        "${json['fecha']}",
        "${json['hacienda']}",
        "${json['suerte']}",
        "${json['horasProgramadas']}",
        "${json['actividad']}",
        "${json['horasEjecutadas']}",
        "${json['pendiente']}",
        "${json['observacion']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
        'hdaSte': hdaSte,
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
        'horasProgramadas': horasProgramadas,
        'actividad': actividad,
        'horasEjecutadas': horasEjecutadas,
        'pendiente': pendiente,
        'observacion': observacion,
      };
}
