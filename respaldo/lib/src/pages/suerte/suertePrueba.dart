class SuertePrueba {
  String area;
  String direccion;
  String haciendaPerteneciente;
  String idSuerte;
  String claveSuerte;
  SuertePrueba(
      {this.area,
      this.direccion,
      this.haciendaPerteneciente,
      this.idSuerte,
      this.claveSuerte});

  factory SuertePrueba.fromJson(Map<String, dynamic> json) {
    return SuertePrueba(
        area: json['area'],
        direccion: json['direccion'],
        haciendaPerteneciente: json['haciendaPerteneciente'],
        idSuerte: json['id_suerte'],
        claveSuerte: json['claveSuerte']);
  }
  Map<String, dynamic> toMap() {
    return {
      'area': area,
      'direccion': direccion,
      'haciendaPerteneciente': haciendaPerteneciente,
      'id_suerte': idSuerte,
      'claveSuerte': claveSuerte
    };
  }
}
