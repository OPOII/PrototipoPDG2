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
  Future<Map<String, dynamic>> sendAndRetrieveMessage(
      String tokenDestino, String titulo, String mensaje) async {
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
          'notification': <String, dynamic>{'body': mensaje, 'title': titulo},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': tokenDestino,
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
