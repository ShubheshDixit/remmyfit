import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:remmifit/models/pills_reminder.dart';
import 'package:remmifit/pages/add_pill_reminder.dart';
import 'package:remmifit/pages/auth_page.dart';
import 'package:remmifit/pages/notification_page.dart';
import 'package:remmifit/pages/web_view_page.dart';
import 'package:remmifit/services/notification_service.dart';
import 'package:awesome_notifications/src/utils/date_utils.dart' as Utils;
import 'package:simple_link_preview/simple_link_preview.dart';
import 'package:uuid/uuid.dart';

class Link {
  final String url;
  final Timestamp timestamp;
  Link({required this.url, required this.timestamp});

  factory Link.fromJSON(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    return Link(url: json['url'], timestamp: json['createdAt']);
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user;
  TextEditingController urlController = TextEditingController();
  List<PillsReminder> userPills = [];
  StreamSubscription? sub;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Notification Permission'),
            content: const Text(
                'We would need you permission to notify you for your reminders. Please allow.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Don\'t Allow',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () {
                  AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context));
                },
                child: const Text(
                  'Allow',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }
    });
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NotificationPage(
          notification: receivedNotification,
        ),
      ));
    });
    getUserPills();
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  Future<void> getUserPills() async {
    // QuerySnapshot<Map<String, dynamic>> docs =
    sub = FirebaseFirestore.instance
        .collection('pill-reminders')
        .snapshots()
        .listen((event) {
      userPills.clear();
      List<PillsReminder> tmp = [];
      event.docs.forEach((element) {
        tmp.add(PillsReminder.fromDoc(element));
      });
      setState(() {
        userPills = tmp;
      });
    });
  }

  Future<void> saveLinkToDB(String url) async {
    String id = const Uuid().v4().replaceAll('-', '').substring(10);
    await FirebaseFirestore.instance.collection('links').doc(id).set(
      {
        'url': url,
        'createdAt': DateTime.now(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('RemmyFit'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await GoogleSignIn().signOut();
              } catch (err) {}
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const AuthPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/health/Drawkit-Vector-Illustration-Medical-18.png',
                    height: 200,
                    width: 400,
                  ),
                  Text(
                    'Hello ${FirebaseAuth.instance.currentUser?.displayName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: userPills.isNotEmpty
                        ? List.generate(
                            userPills.length,
                            (index) {
                              return ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                tileColor: Colors.grey.shade800,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                leading: Image.asset(
                                  'assets/health/Drawkit-Vector-Illustration-Medical-07.png',
                                  width: 50,
                                  height: 50,
                                ),
                                minLeadingWidth: 0,
                                title: Text(
                                  userPills[index].pillName,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900),
                                ),
                                subtitle: Text(
                                  userPills[index].pillAmount.toString() +
                                      ' Pills',
                                ),
                                trailing: Text(
                                  NotificationTime.fromJSON(
                                          userPills[index].notifications[0])
                                      .toString(),
                                ),
                              );
                            },
                          )
                        : [
                            ListTile(
                              leading: Image.asset(
                                'assets/health/Drawkit-Vector-Illustration-Medical-12.png',
                              ),
                              title: const Text(
                                'No reminders yet!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            )
                          ],
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AddPillReminder(),
                          ),
                        );
                      },
                      icon: const Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        'Add a reminder',
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
                  const SizedBox(
                    height: 20,
                  ),
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 60,
                  //   child: ElevatedButton.icon(
                  //     onPressed: () async {
                  //       // AwesomeNotifications().createNotification(
                  //       //   content: NotificationContent(
                  //       //     id: 10,
                  //       //     channelKey: 'remmyfit_channel',
                  //       //     title: 'Simple Notification',
                  //       //     body: 'Simple body',
                  //       //   ),
                  //       // );
                  //       // String localTimeZone = await AwesomeNotifications()
                  //       //     .getLocalTimeZoneIdentifier();
                  //       // DateTime scheduleTime =
                  //       //     DateTime.now().add(const Duration(seconds: 5));

                  //       List<NotificationModel> notifications =
                  //           await AwesomeNotifications()
                  //               .listScheduledNotifications();
                  //       notifications.forEach((element) async {
                  //         print(element);
                  //         // await AwesomeNotifications().cancelSchedule(
                  //         //   element.content?.id ?? 1,
                  //         // );
                  //       });
                  //     },
                  //     icon: const Icon(
                  //       FontAwesomeIcons.plus,
                  //       color: Colors.white,
                  //       size: 18,
                  //     ),
                  //     label: Text(
                  //       'Show Notification',
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
                  //         fontFamily:
                  //             GoogleFonts.poppins(fontWeight: FontWeight.bold)
                  //                 .fontFamily,
                  //         fontSize: 18,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LinkTile extends StatefulWidget {
  final String url;
  const LinkTile({Key? key, required this.url}) : super(key: key);

  @override
  _LinkTileState createState() => _LinkTileState();
}

class _LinkTileState extends State<LinkTile> {
  bool isLoading = false;
  LinkPreview? linkData;
  @override
  void initState() {
    super.initState();
    getLinkData();
  }

  Future<void> getLinkData() async {
    setState(() {
      isLoading = true;
    });
    LinkPreview? preview = await SimpleLinkPreview.getPreview(widget.url);
    setState(() {
      linkData = preview;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (linkData == null) {
      return const Center(child: CircularProgressIndicator.adaptive());
    } else {
      return linkData != null
          ? GestureDetector(
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(url: linkData!.url),
                  ),
                );
              },
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      linkData!.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                linkData!.image!,
                                height: 80,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const SizedBox(),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            linkData!.title!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  )),
            )
          : const Center(child: CircularProgressIndicator.adaptive());
    }
  }
}
