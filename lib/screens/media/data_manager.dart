import 'dart:async';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class DataManager {
  DataManager({
    required this.flickManager,
    required this.urls,
    // required this.titles,
    required this.currentPlaying,
  });

  int currentPlaying;
  final FlickManager flickManager;
  final List<String> urls;
  // final List<String> titles;

  late Timer videoChangeTimer;

  // String getTitle() {
  //   print(currentPlaying);
  //   return titles[currentPlaying];
  // }

  String getNextVideo() {
    currentPlaying++;
    return urls[currentPlaying];
  }

  bool hasNextVideo() {
    return currentPlaying != urls.length - 1;
  }

  bool hasPreviousVideo() {
    return currentPlaying != 0;
  }

  skipToNextVideo([Duration? duration]) {
    if (hasNextVideo()) {
      flickManager.handleChangeVideo(
          VideoPlayerController.network(urls[currentPlaying + 1]),
          videoChangeDuration: duration);

      currentPlaying++;
    }
  }

  skipToPreviousVideo() {
    if (hasPreviousVideo()) {
      currentPlaying--;
      flickManager.handleChangeVideo(
          VideoPlayerController.network(urls[currentPlaying]));
    }
  }

  cancelVideoAutoPlayTimer({required bool playNext}) {
    if (playNext != true) {
      currentPlaying--;
    }

    flickManager.flickVideoManager
        ?.cancelVideoAutoPlayTimer(playNext: playNext);
  }
}
