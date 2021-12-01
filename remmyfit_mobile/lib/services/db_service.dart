import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remmifit/models/pills_reminder.dart';
import 'package:remmifit/pages/add_pill_reminder.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  DatabaseService._();

  factory DatabaseService() => instance;

  static final DatabaseService instance = DatabaseService._();

  static getPillTime(PillTakeTime pillTakeTime) {
    switch (pillTakeTime) {
      case PillTakeTime.withFood:
        return 'withFood';
      case PillTakeTime.afterFood:
        return 'afterFood';
      case PillTakeTime.beforeFood:
        return 'beforeFood';
      default:
        return 'withFood';
    }
  }

  static pillTimeFromString(String pillTakeTime) {
    switch (pillTakeTime) {
      case 'PillTakeTime.withFood':
        return PillTakeTime.withFood;
      case 'PillTakeTime.afterFood':
        return PillTakeTime.afterFood;
      case 'PillTakeTime.beforeFood':
        return PillTakeTime.beforeFood;
      default:
        return PillTakeTime.withFood;
    }
  }

  Future<void> addPillReminder(
      String id,
      String pillName,
      int pillAmount,
      int days,
      PillTakeTime pillTakeTime,
      List<Map> notifications,
      List<int> notificationsId) async {
    await FirebaseFirestore.instance.collection('pill-reminders').doc(id).set({
      'pillName': pillName,
      'pillAmount': pillAmount,
      'days': days,
      'pillTakeTime': pillTakeTime.toString(),
      'notifications': notifications,
      'notificationsId': notificationsId,
      'startTime': Timestamp.now(),
    });
  }
}
