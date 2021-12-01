import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remmifit/pages/add_pill_reminder.dart';
import 'package:remmifit/pages/web_view_page.dart';
import 'package:remmifit/services/notification_service.dart';
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
  List<Link> userLinks = [];
  StreamSubscription? sub;
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    // getUserLinks();
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  Future<void> getUserLinks() async {
    // QuerySnapshot<Map<String, dynamic>> docs =
    sub = FirebaseFirestore.instance
        .collection('links')
        .snapshots()
        .listen((event) {
      userLinks.clear();
      List<Link> tmp = [];
      event.docs.forEach((element) {
        tmp.add(Link.fromJSON(element));
      });
      setState(() {
        userLinks = tmp;
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
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(userLinks.length, (index) {
                      return LinkTile(url: userLinks[index].url);
                    }),
                  ),
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        AwesomeNotifications()
                            .isNotificationAllowed()
                            .then((isAllowed) {
                          if (!isAllowed) {
                            // This is just a basic example. For real apps, you must show some
                            // friendly dialog box before call the request method.
                            // This is very important to not harm the user experience
                            AwesomeNotifications()
                                .requestPermissionToSendNotifications();
                          }
                        });
                      },
                      icon: const Icon(
                        FontAwesomeIcons.plus,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        'Show Notification',
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
