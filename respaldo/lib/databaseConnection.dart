import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

Future dataBaseConnection() async {
  var settings = new ConnectionSettings(
      host: 'b67wktweut6nonxn1bee-mysql.services.clever-cloud.com',
      port: 3306,
      user: 'uwp7v1kyyu8fpkvd',
      password: 'SKUF1tydUEoCSjkgH9gh',
      db: 'b67wktweut6nonxn1bee');
  var conn = await MySqlConnection.connect(settings);
  var results = await conn
      .query('SELECT * FROM USERS WHERE IDENTIFICATION_CARD = ?', [1111122222]);
  for (var row in results) {
    print(
        'Id Activity: ${row[0]}, Hacienda Name: ${row[1]}, Start date: ${row[2]}, Suerte name: ${row[3]}, Progtamed hours: ${row[4]}, Actibity Name: ${row[5]}, hours done: ${row[6]}, missing hours: ${row[7]}, observation: ${row[8]}, id suerte: ${row[9]}, user id: ${row[10]}');
  }
}
