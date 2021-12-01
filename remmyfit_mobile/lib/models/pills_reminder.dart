import 'package:cloud_firestore/cloud_firestore.dart';

class PillsReminder {
  final String pillName;
  final int pillAmount, days;
  final PillTakeTime pillTakeTime;
  final Timestamp startTime;
  final List notifications;

  PillsReminder(this.pillName, this.pillAmount, this.days, this.pillTakeTime,
      this.notifications, this.startTime);
}

enum PillTakeTime {
  beforeFood,
  withFood,
  afterFood,
}
