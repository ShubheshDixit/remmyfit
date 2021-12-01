import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remmifit/models/pills_reminder.dart';
import 'package:remmifit/services/db_service.dart';
import 'package:awesome_notifications/src/utils/date_utils.dart' as Utils;
import 'package:uuid/uuid.dart';

class AddPillReminder extends StatefulWidget {
  const AddPillReminder({Key? key}) : super(key: key);

  @override
  _AddPillReminderState createState() => _AddPillReminderState();
}

class _AddPillReminderState extends State<AddPillReminder> {
  PillTakeTime pillTakeTime = PillTakeTime.withFood;
  String? pillName;
  int? pillAmount, days;
  List<NotificationTime> notificationsTime = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pill Reminder'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Add Plan',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Add a pill plan and get reminder so you never miss having that pill and recover faster.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/health/Drawkit-Vector-Illustration-Medical-16.png',
                      height: 140,
                      width: 140,
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Pill Name',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Center(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          pillName = value;
                        });
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.prescription),
                        hintText: 'Enter Pill Name',
                        // label: Text('Pill Name'),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Amount & How long?',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                pillAmount = int.tryParse(value);
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(FontAwesomeIcons.pills),
                              suffix: Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text('pills'),
                              ),
                              hintText: 'No. of pills',
                              // label: Text('Pill Name'),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Container(
                        height: 60,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                days = int.tryParse(value);
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(FontAwesomeIcons.calendarDay),
                              hintText: 'Days',
                              suffix: Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Text('days'),
                              ),
                              // label: Text('Pill Name'),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Food & Pill Taking Time',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 130),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade800,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0).add(
                                            const EdgeInsets.only(top: 20)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Text(
                                                          'Pills Time Info',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Information on what each pill button means.',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey.shade500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    icon: const Icon(
                                                        FontAwesomeIcons.times),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              thickness: 1,
                                            ),
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 90,
                                                    width: 90,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color:
                                                          Colors.grey.shade900,
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              child: Container(
                                                                height: 10,
                                                                width: 10,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          const Icon(
                                                              FontAwesomeIcons
                                                                  .utensils),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Before Meal',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 18,
                                                            color: Colors
                                                                .grey.shade300,
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            'This button signinfies that the pill is to be taken a while before having a meal.',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.grey
                                                                  .shade500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 90,
                                                    width: 90,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color:
                                                          Colors.grey.shade900,
                                                    ),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const Icon(
                                                              FontAwesomeIcons
                                                                  .utensils),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              child: Container(
                                                                height: 10,
                                                                width: 10,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'With Meal',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 18,
                                                            color: Colors
                                                                .grey.shade300,
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            'This button signinfies that the pill is to be taken along with your meal.',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.grey
                                                                  .shade500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 90,
                                                    width: 90,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color:
                                                          Colors.grey.shade900,
                                                    ),
                                                    child: Center(
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          const Icon(
                                                              FontAwesomeIcons
                                                                  .utensils),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              child: Container(
                                                                height: 10,
                                                                width: 10,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Flexible(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'After Meal',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 18,
                                                            color: Colors
                                                                .grey.shade300,
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            'This button signinfies that the pill is to be taken a while after you have had meal.',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.grey
                                                                  .shade500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Image.asset(
                                        'assets/health/Drawkit-Vector-Illustration-Medical-17.png',
                                        height: 200,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      icon: const Icon(FontAwesomeIcons.infoCircle),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          pillTakeTime = PillTakeTime.beforeFood;
                        });
                      },
                      child: Container(
                        height: 90,
                        width: 90,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: pillTakeTime == PillTakeTime.beforeFood
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade800,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const Icon(FontAwesomeIcons.utensils),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          pillTakeTime = PillTakeTime.withFood;
                        });
                      },
                      child: Container(
                        height: 90,
                        width: 90,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: pillTakeTime == PillTakeTime.withFood
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade800,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(FontAwesomeIcons.utensils),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          pillTakeTime = PillTakeTime.afterFood;
                        });
                      },
                      child: Container(
                        height: 90,
                        width: 90,
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: pillTakeTime == PillTakeTime.afterFood
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade800,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(FontAwesomeIcons.utensils),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Container(
                                    height: 10,
                                    width: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: List.generate(
                    notificationsTime.length,
                    (index) {
                      return Container(
                        // height: 60,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade800,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(FontAwesomeIcons.clock),
                                  ),
                                  Text(
                                    notificationsTime[index].toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    notificationsTime
                                        .remove(notificationsTime[index]);
                                  });
                                },
                                icon: const Icon(FontAwesomeIcons.timesCircle),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          notificationsTime.add(
                            NotificationTime(
                                time.hour, time.minute, time.period),
                          );
                        });
                      }
                    },
                    icon: const Icon(
                      FontAwesomeIcons.clock,
                      size: 18,
                    ),
                    label: Text(
                      'Add a notification',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            GoogleFonts.poppins(fontWeight: FontWeight.bold)
                                .fontFamily,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: !(pillName != null &&
                            pillAmount != null &&
                            days != null)
                        ? null
                        : () async {
                            String id = const Uuid()
                                .v4()
                                .replaceAll('-', '')
                                .substring(10);
                            List<int> notificationsId = [];
                            for (int i = 0; i < notificationsTime.length; i++) {
                              int notifId =
                                  (DateTime.now().millisecondsSinceEpoch /
                                              1000000 +
                                          i)
                                      .toInt();
                              notificationsId.add(notifId);
                            }

                            if (pillName != null &&
                                pillAmount != null &&
                                days != null) {
                              List<Map> notifications = [];

                              notificationsTime.forEach((element) {
                                notifications.add(element.toJson());
                              });
                              await DatabaseService.instance.addPillReminder(
                                id,
                                pillName ?? '',
                                pillAmount ?? 0,
                                days ?? 0,
                                pillTakeTime,
                                notifications,
                                notificationsId,
                              );
                            }
                            if (notificationsTime.isNotEmpty) {
                              for (int i = 0;
                                  i < notificationsTime.length;
                                  i++) {
                                DateTime scheduleTime = DateTime.now().add(
                                  const Duration(seconds: 5),
                                );
                                String localTimeZone =
                                    await AwesomeNotifications()
                                        .getLocalTimeZoneIdentifier();

                                await AwesomeNotifications().createNotification(
                                  content: NotificationContent(
                                    id: notificationsId[i],
                                    channelKey: 'remmyfit_channel',
                                    title: 'Time to take your pill.',
                                    body: 'Your pill $pillName was schedule to be taken at ' +
                                        (Utils.DateUtils.parseDateToString(
                                                scheduleTime.toLocal()) ??
                                            '?') +
                                        ' $localTimeZone. Please take $pillAmount pills and get well soon.',
                                    wakeUpScreen: true,
                                    category: NotificationCategory.Reminder,
                                    notificationLayout:
                                        NotificationLayout.BigPicture,
                                    bigPicture:
                                        'asset://assets/images/health/Drawkit-Vector-Illustration-Medical-07.png',
                                    payload: {'id': id},
                                  ),
                                  schedule: NotificationCalendar(
                                    timeZone: localTimeZone,
                                    hour: notificationsTime[i].hour,
                                    minute: notificationsTime[i].minute,
                                  ),
                                );
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text(
                                      'Pill Reminder Created Successfully!',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Done'),
                                      )
                                    ],
                                  ),
                                ).then(
                                  (value) => Navigator.of(context).pop(),
                                );
                              }
                            }
                          },
                    icon: const Icon(
                      FontAwesomeIcons.save,
                      color: Colors.white,
                      size: 18,
                    ),
                    label: Text(
                      'Save Reminder',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            GoogleFonts.poppins(fontWeight: FontWeight.bold)
                                .fontFamily,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationTime {
  final int hour, minute;
  DayPeriod period;
  NotificationTime(this.hour, this.minute, this.period);

  Map toJson() {
    return {
      'hour': hour,
      'minute': minute,
      'period': _getPeriod(period),
    };
  }

  factory NotificationTime.fromJSON(Map json) {
    return NotificationTime(
        json['hour'], json['minute'], _fromPeriod(json['period']));
  }

  static String _getPeriod(DayPeriod period) {
    return period == DayPeriod.am ? 'AM' : 'PM';
  }

  static DayPeriod _fromPeriod(String period) {
    return period == 'AM' ? DayPeriod.am : DayPeriod.pm;
  }

  String _getTowDigitNumbers(int number) {
    return number >= 10 ? number.toString() : '0' + number.toString();
  }

  @override
  String toString() {
    return _getTowDigitNumbers(hour) +
        ":" +
        _getTowDigitNumbers(minute) +
        _getPeriod(period);
  }
}
