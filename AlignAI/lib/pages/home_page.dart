import 'package:align_ai/main.dart';
import 'package:align_ai/pages/profile_page.dart';
import 'package:align_ai/pages/tabs/recipe_tab.dart';
import 'package:align_ai/pages/tabs/tracker_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:camera/camera.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'tabs/align_tab.dart';
import 'package:align_ai/pages/tabs/workouts_tab.dart';

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  HomePage(this.cameras);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static List<Widget> _tabs = <Widget>[
    WorkoutTab(),
    TrackerTab(),
    AlignTab(cameras),
    RecipeTab(),
  ];

  static List<String> _tabNames = <String>[
    "Workouts",
    "Tracker",
    "Align",
    "Recipes"
  ];

  // String userPhoto = FirebaseAuth.instance.currentUser?.photoURL ?? "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(38, 38, 38, 1),
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _tabNames[_selectedIndex],
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => const ProfilePage()),
              //     );
              //   },
              //   borderRadius: BorderRadius.circular(10),
              //   child: CircleAvatar(
              //     backgroundColor: Colors.amber,
              //     radius: 30.0,
              //     child: CircleAvatar(
              //       backgroundImage: NetworkImage(userPhoto),
              //       radius: 28.0,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: Center(
        child: _tabs.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //fixedColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.burn),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.calendar_check),
            label: 'Tracker',
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.universal_access),
            label: 'Align',
          ),
          BottomNavigationBarItem(
            icon: Icon(LineAwesomeIcons.cookie_bite),
            label: 'Recipes',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.amber,
        iconSize: 36.0,
        elevation: 0.0,
        onTap: _onItemTapped,
      ),
    );
  }
}
