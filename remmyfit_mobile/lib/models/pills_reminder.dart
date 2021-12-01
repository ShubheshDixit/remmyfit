import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remmifit/services/db_service.dart';

class PillsReminder {
  final String pillName;
  final int pillAmount, days;
  final PillTakeTime pillTakeTime;
  final Timestamp? startTime;
  final List notifications;

  PillsReminder(this.pillName, this.pillAmount, this.days, this.pillTakeTime,
      this.notifications, this.startTime);

  factory PillsReminder.fromDoc(DocumentSnapshot doc) {
    return PillsReminder(
      doc.get('pillName'),
      doc.get('pillAmount'),
      doc.get('days'),
      DatabaseService.pillTimeFromString(doc.get('pillTakeTime')),
      doc.get('notifications'),
      doc.get('startTime'),
    );
  }
}

enum PillTakeTime {
  beforeFood,
  withFood,
  afterFood,
}
