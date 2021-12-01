import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  factory NotificationService() => instance;

  static final NotificationService instance = NotificationService._();

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('remmyfit_rem', 'remmyfit_rem',
          channelDescription: 'remmy fit reminder channel',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');

  void onDidReceiveLocalNotification(int id, String? title, String? body,
      String? payload, BuildContext context) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ''),
        content: Text(body ?? ''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: Center(
                      child: ListTile(
                        title: Text(payload.toString()),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Future<void> scheduleNotification() async {
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Testing schedule',
      'This is a test notification!',
      tz.TZDateTime.from(
          DateTime.now().add(const Duration(seconds: 20)), tz.local),
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: '',
    );
  }

  Future<void> showNotification() async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: 1),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Title',
      'Body',
      platformChannelSpecifics,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> init(BuildContext context) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) {
      onDidReceiveLocalNotification(id, title, body, payload, context);
    });
    if (Platform.isIOS) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: const AndroidInitializationSettings('ic_launcher'),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
      if (payload != null) {
        print(payload);
      }
    });
  }
}
