import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class Services {
  String body;
  Services();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final String serverToken =
      "AAAAmxMwoxU:APA91bFCUe2VQ6573KLpxubdN_cKhpK0MkQCY2O1f8DACIGEBfXNmQ_8mptBvbLR1Cv87KxL5gZYg6GdTGtPowkQpss9Tu90kMmcfCiTOzKNnpoS8oLPzo1hK45s99DM59LWRarMxOSK";
  //Esto es para enviar el mensaje de notificacion
  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
          sound: true, badge: true, alert: true, provisional: false),
    );

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Enviame un screen shot de la notificacion',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to':
              "dNgzK0QfTS-d5-BL1PlL8-:APA91bEakU-jYYZvORa9S7IJmch5Xj_Q29cAMqFWjw6E9YKAOpE2UoEclnTdYpGObmtXlUzMPATXfpZHqIps8q1XltNy7gBCaz107xpW38Tgp2U9X4F10rfxM_47aL_xgMp70vMWsVRH",
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );

    return completer.future;
  }
}
