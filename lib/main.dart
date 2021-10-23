import 'package:edutopik/screens/media/player_screen.dart';
import 'package:edutopik/screens/splash_screen.dart';
import 'package:edutopik/screens/test.dart';
import 'package:edutopik/widget/web_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Splash(),
          );
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EDU-TOPIK',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: JSTest(),
          );
        }
      },
    );
  }
}
