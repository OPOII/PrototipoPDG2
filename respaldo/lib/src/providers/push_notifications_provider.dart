import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _streamController = StreamController<String>.broadcast();
  Stream<String> get mensajes => _streamController.stream;
  String tokenDispositivo;
  String tokenActual;
  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      print('===== FCM ==========');
      tokenActual = token;
      print(token);
      //f8qcHr3vSB218d6Gs0Au1T:APA91bHzdLSFei1aHzgVTXJchNYs_QU_oypRcBZ0_Icl_2PmHwgkZ808ciXdQglLCUgSNidcszVICes3AwLIAELQEzJpl7wOTRzVdrXKiCPQA3Af3h9tf5amFTcrQUOb6ZsOPTxP6TXe
      //Hay que guardar este token en una base de datos
    });

    // ignore: missing_return
    _firebaseMessaging.configure(onMessage: (info) {
      print('===== On Message ==========');
      print(info);
      var argument = 'no-data';
      if (Platform.isAndroid) {
        argument = info['data']['Comida'] ?? 'no-data';
      }
      _streamController.sink.add(argument);
      // ignore: missing_return
    }, onLaunch: (info) {
      print('===== On Launch ==========');
      print(info);
      // ignore: missing_return
    }, onResume: (info) {
      print('===== On Resume ==========');
      print(info);
      final noti = info['data']['Comida'];
      print(noti);
    });
  }

  dispose() {
    _streamController?.close();
  }
}
