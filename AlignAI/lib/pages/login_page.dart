import 'dart:math' as math;

import 'package:align_ai/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  static String routeName = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  signInWithGoogle() async {
    GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print(userCredential.user.displayName);

    await addUserToDB(
        userCredential.user.displayName, userCredential.user.email);
    print("User added to DB");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(38, 38, 38, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'hero',
              child: SizedBox(
                width: 300,
                height: 300,
                child: Image.asset('assets/logo.jpg'),
              ),
            ),
            const Text(
              "Fitness Tracking\nLike never befores",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                signInWithGoogle();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber)),
              child: SizedBox(
                width: 250,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Sign in with Google",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Image.asset('assets/google.png'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
