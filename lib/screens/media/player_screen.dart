import 'package:edutopik/screens/media/play_time.dart';
import 'package:edutopik/screens/media/player.dart';
import 'package:flutter/material.dart';

class PlayerScreen extends StatefulWidget {
  PlayerScreen({Key? key, required this.urls, required this.titles, required this.playTime})
      : super(key: key);
  List<String> urls;
  List<String> titles;
  PlayTime playTime;
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Player(
          urls: widget.urls,
          playTime: widget.playTime,
          titles: widget.titles,
        ),
      ),
    );
  }
}
