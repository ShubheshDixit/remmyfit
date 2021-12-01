import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remmifit/models/pills_reminder.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  DatabaseService._();

  factory DatabaseService() => instance;

  static final DatabaseService instance = DatabaseService._();

  Future<void> addPillReminder(String pillName, int pillAmount, int days,
      PillTakeTime pillTakeTime, List notifications) async {
    String id = const Uuid().v4().replaceAll('-', '').substring(10);
    FirebaseFirestore.instance.collection('pill-reminders').doc(id).set({
      'pillName': pillName,
      'pillAmount': pillAmount,
      'days': days,
      'pillTakeTime': pillTakeTime.toString(),
      'notifications': notifications,
    });
  }
}
