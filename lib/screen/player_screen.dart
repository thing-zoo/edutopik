import 'package:edutopik/widget/player.dart';
import 'package:flutter/material.dart';

class PlayerScreen extends StatefulWidget {
  PlayerScreen({Key? key}) : super(key: key);

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          child: DefaultPlayer(),
          height: MediaQuery.of(context).size.width * (9 / 16),
        ),
      ),
    );
  }
}