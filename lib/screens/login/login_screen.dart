import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:edutopik/screens/login/components/body.dart';

//Show Loin screen
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Firebase load fail"),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Body();
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
