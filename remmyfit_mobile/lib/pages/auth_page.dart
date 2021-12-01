import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:remmifit/pages/home.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  StreamSubscription<User?>? sub;
  Future<UserCredential> signInWithGoogle() async {
    setState(() {
      isProcessing = true;
    });
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    setState(() {
      isProcessing = false;
    });

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void initState() {
    super.initState();
    sub = FirebaseAuth.instance.authStateChanges().listen((event) {
      if (mounted) {
        if (event != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const Home(),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    if (sub != null) {
      sub?.cancel();
    }
    super.dispose();
  }

  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/health/Drawkit-Vector-Illustration-Medical-06.png',
              height: 300,
              width: 300,
            ),
            Text(
              'Welcome to RemmyFit',
              style: TextStyle(
                // color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily:
                    GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: isProcessing
                    ? null
                    : () async {
                        UserCredential cred = await signInWithGoogle();
                        if (cred.user != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const Home(),
                            ),
                          );
                        }
                      },
                icon: isProcessing
                    ? const SizedBox()
                    : const Icon(
                        FontAwesomeIcons.google,
                        size: 18,
                        color: Colors.white,
                      ),
                label: isProcessing
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : Text(
                        'Sign In With Google',
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
            // Container(
            //   width: 300,
            //   height: 60,
            //   margin: const EdgeInsets.symmetric(vertical: 20.0),
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade800,
            //     borderRadius: BorderRadius.circular(5),
            //   ),
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: const Center(
            //     child: TextField(
            //       decoration: InputDecoration(
            //         border: InputBorder.none,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
