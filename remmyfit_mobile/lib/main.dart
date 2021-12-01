import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remmifit/pages/auth_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  tz.initializeTimeZones();
  // tz.setLocalLocation(tz.getLocation('India/Delhi'));
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/ic_launcher.png',
    [
      NotificationChannel(
          channelGroupKey: 'remmyfit_group',
          channelKey: 'remmyfit_channel',
          channelName: 'RemmyFit',
          channelDescription: 'Notification channel for pills tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white),
      // Channel groups are only visual and are not required
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupkey: 'remmyfit_group',
        channelGroupName: 'RemmyFit',
      )
    ],
    debug: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      title: 'RemmyFit',
      darkTheme: ThemeData(
          fontFamily: GoogleFonts.poppins().fontFamily,
          colorScheme: ColorScheme.dark(
            primary: const Color(0xff6562ce),
            primaryVariant: const Color(0xffa6a4e4),
            secondary: const Color(0xffe0a106),
            secondaryVariant: const Color(0xffe0a106),
            background: Colors.grey.shade900,
          )),
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: ColorScheme.light(
          primary: const Color(0xff6562ce),
          primaryVariant: const Color(0xffa6a4e4),
          secondary: const Color(0xffe0a106),
          secondaryVariant: const Color(0xffe0a106),
          background: Colors.grey.shade200,
        ),
      ),
      home: const AuthPage(),
    );
  }
}
