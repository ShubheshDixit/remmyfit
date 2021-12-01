import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationService {
  NotificationService._();

  factory NotificationService() => instance;

  static final NotificationService instance = NotificationService._();

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

  Future<void> init(BuildContext context) async {}
}
