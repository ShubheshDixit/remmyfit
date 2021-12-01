import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  // NotificationSettings settings;
  bool _initialized = false;

  Future<void> init(context) async {
    // settings = await messaging.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );
    // print('User granted permission: ${settings.authorizationStatus}');
    if (!_initialized) {
      // String token = await messaging.getToken();
      // use the returned token to send messages to users from your custom server
      // print("FirebaseMessaging token: $token");

      // var notifPerm = await Permission.notification.request();
      // if (notifPerm.isGranted) _hasPermission = true;

      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   print('Got a message whilst in the foreground!');
      //   print('Message data: ${message.data}');

      //   if (message.notification != null) {
      //     print(
      //         'Message also contained a notification: ${message.notification}');
      //   }
      // });
      //   _firebaseMessaging.configure(
      //     onMessage: (Map<String, dynamic> message) async {
      //       print("onMessage: $message");
      //       await _handleNotification(context, message['data']);
      //     },
      //     onResume: (message) async {
      //       print("onMessage: $message");
      //       await _handleNotification(context, message['data']);
      //     },
      //     onLaunch: (message) async {
      //       await _handleNotification(context, message['data']);
      //     },
      //     onBackgroundMessage: myBackgroundMessageHandler,
      //   );
      //   await _saveToken(token);
      //   _initialized = true;
      // } else {
      //   _firebaseMessaging.requestNotificationPermissions();
      // }
    }
  }

  Future<void> _handleNotification(context, data) async {
    if (data['type'] == 'room') {
      var details = jsonDecode(data['details']);
      print(details);
      String roomId = details['roomId'];
      String password = details['password'];
      String subject = details['subject'];
      if (roomId != null || roomId != 'null') {
        await Navigator.pushNamed(context,
            '/room?roomId=$roomId&password=$password&subject=$subject');
      }
    }
  }

  Future<void> _saveToken(token) async {
    if (FirebaseAuth.instance.currentUser != null) {
      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('tokens')
          .doc(token)
          .get();
      if (!doc.exists) {
        await doc.reference.set({
          'token': token,
          'userId': FirebaseAuth.instance.currentUser?.uid,
          'createdAt': DateTime.now(),
          'platform': kIsWeb ? 'web' : Platform.operatingSystem
        });
      }
    }
  }
}
