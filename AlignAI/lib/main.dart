import 'package:align_ai/pages/exercise_detail_page.dart';
import 'package:align_ai/pages/exercise_list_page.dart';
import 'package:align_ai/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';

import 'package:align_ai/pages/tabs/align_tab.dart';
import 'package:align_ai/pages/home_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

List<CameraDescription> cameras;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Paint.enableDithering = true;
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    // LoginPage.routeName: (context) => LoginPage(),
    // Home.routeName: (context) => Home(),
    AlignTab.id: (context) => AlignTab(cameras),
    ExerciseListPage.routeName: (context) => ExerciseListPage(),
    ExerciseDetailPage.routeName: (context) => ExerciseDetailPage(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: const Color.fromRGBO(38, 38, 38, 1),
            onPrimary: Colors.amber,
            secondary: const Color.fromARGB(255, 46, 46, 46),
            onSecondary: Colors.purple,
            error: Colors.red.shade300,
            onError: const Color.fromARGB(255, 46, 46, 46),
            background: const Color.fromRGBO(38, 38, 38, 1),
            onBackground: Colors.white,
            surface: const Color.fromARGB(255, 46, 46, 46),
            onSurface: Colors.white),
      ),
      home: HomePage(cameras),
      // home: StreamBuilder<User>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return Text(snapshot.error.toString());
      //     }
      //     if (snapshot.connectionState == ConnectionState.active) {
      //       if (snapshot.data == null) {
      //         return LoginPage();
      //       }
      //     }
      //     return HomePage(cameras);
      //   },
      // ),
      routes: routes,
    );
  }
}
