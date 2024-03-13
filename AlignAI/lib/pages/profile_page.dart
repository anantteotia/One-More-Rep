import 'package:align_ai/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage();

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = FirebaseAuth.instance.currentUser?.displayName;
  String userEmail = FirebaseAuth.instance.currentUser?.email;
  String userPhoto = FirebaseAuth.instance.currentUser?.photoURL;

  logout() async {
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
    await removeUserFromDB(FirebaseAuth.instance.currentUser.email);
    print("User removed from DB");
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(38, 38, 38, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(38, 38, 38, 1),
        title: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Profile",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            CircleAvatar(
              backgroundColor: Colors.amber,
              radius: 55.0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(userPhoto),
                radius: 53.0,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              userEmail,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: logout,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
