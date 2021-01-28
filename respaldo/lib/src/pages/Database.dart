import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:respaldo/src/pages/tarea/tarea.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DataBaseOffLine {
  static final _dbName = 'Pruebas.db';
  static final _dbVersion = 1;
  static final _tableName = 'TASKS';

  static final columnId = 'id';
  static final columnhdaste = 'hdaste';
  static final columnarea = 'area';
  static final columncorte = 'corte';
  static final columnedad = 'edad';
  static final columnnombreActividad = 'nombreActividad';
  static final columngrupo = 'grupo';
  static final columndistrito = 'distrito';
  static final columntipoCultivo = 'tipoCultivo';
  static final columnnombreHacienda = 'nombreHacienda';
  static final columnfecha = 'fecha';
  static final columnhacienda = 'hacienda';
  static final columnsuerte = 'suerte';
  static final columnprograma = 'programa';
  static final columnactividad = 'actividad';
  static final columnejecutable = 'ejecutable';
  static final columnpendiente = 'pendiente';
  static final columnobservacion = 'observacion';
  static final columnencargado = 'encargado';
  DataBaseOffLine._privateConstructor();
  static final DataBaseOffLine instance = DataBaseOffLine._privateConstructor();

  static Database _dataBase;
  Future<Database> get database async {
    if (_dataBase != null) return _dataBase;
    _dataBase = await _initiateDatabase();
    return _dataBase;
  }

  _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("create table " +
        _tableName +
        " (" +
        columnId +
        " integer primary key, " +
        columnhdaste +
        " text, " +
        columnarea +
        " text, " +
        columncorte +
        " text, " +
        columnedad +
        " text," +
        columnnombreActividad +
        " text, " +
        columngrupo +
        " text, " +
        columndistrito +
        " text, " +
        columntipoCultivo +
        " text, " +
        columnnombreHacienda +
        " text, " +
        columnfecha +
        " text, " +
        columnhacienda +
        " text, " +
        columnsuerte +
        " text," +
        columnprograma +
        " text, " +
        columnactividad +
        " text," +
        columnejecutable +
        " text, " +
        columnpendiente +
        " text, " +
        columnobservacion +
        " text, " +
        columnencargado +
        " text)");
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query(_tableName);
  }

  clearTable() async {
    Database db = await instance.database;
    db.execute("delete from " + _tableName);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    db.update(_tableName, row, where: '$columnId=?', whereArgs: [id]);
  }

  llenarTabla(List<Tarea> listado) {
    for (var i = 0; i < listado.length; i++) {
      insert({
        DataBaseOffLine.columnhdaste: listado[i].hdaste,
        DataBaseOffLine.columnarea: listado[i].area,
        DataBaseOffLine.columncorte: listado[i].corte,
        DataBaseOffLine.columnedad: listado[i].edad,
        DataBaseOffLine.columnnombreActividad: listado[i].nombreActividad,
        DataBaseOffLine.columngrupo: listado[i].grupo,
        DataBaseOffLine.columndistrito: listado[i].distrito,
        DataBaseOffLine.columntipoCultivo: listado[i].tipoCultivo,
        DataBaseOffLine.columnnombreHacienda: listado[i].nombreHacienda,
        DataBaseOffLine.columnfecha: listado[i].fecha,
        DataBaseOffLine.columnhacienda: listado[i].hacienda,
        DataBaseOffLine.columnsuerte: listado[i].suerte,
        DataBaseOffLine.columnprograma: listado[i].programa,
        DataBaseOffLine.columnactividad: listado[i].actividad,
        DataBaseOffLine.columnejecutable: listado[i].ejecutable,
        DataBaseOffLine.columnpendiente: listado[i].pendiente,
        DataBaseOffLine.columnobservacion: listado[i].observacion,
        DataBaseOffLine.columnencargado: listado[i].encargado,
      });
    }
  }
}
