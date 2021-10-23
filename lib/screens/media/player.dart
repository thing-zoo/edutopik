import 'package:edutopik/screens/media/media_control.dart';
import 'package:edutopik/models/mock_data.dart'; //임시로 아무데나 만듦
import 'package:edutopik/screens/media/data_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {
  Player({Key? key}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late FlickManager flickManager;
  late DataManager dataManager;
  /* 백엔드: 전체 동영상 여기에 리스트로 넣도록~~ */
  List<String> urls = (mockData["items"] as List)
      .map<String>((item) => item["trailer_url"])
      .toList();

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(
          urls[0], /* 백엔드: 현재 강의 동영상은 여기 넣으면 됩니당~ */
        ),
        onVideoEnd: () {
          dataManager.skipToNextVideo(Duration(seconds: 5));
        });

    dataManager = DataManager(flickManager: flickManager, urls: urls);
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  skipToVideo(String url) {
    flickManager.handleChangeVideo(VideoPlayerController.network(url));
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction == 0 && this.mounted) {
          flickManager.flickControlManager?.autoPause();
        } else if (visibility.visibleFraction == 1) {
          flickManager.flickControlManager?.autoResume();
        }
      },
      child: Container(
        child: FlickVideoPlayer(
          flickManager: flickManager,
          preferredDeviceOrientation: [
            //바로 전체화면 되도록!
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
          systemUIOverlay: [], //하단바,상단바 없애줌
          flickVideoWithControls: FlickVideoWithControls(
            videoFit: BoxFit.fitWidth,//영상을 safearea에 맞게
            controls: MediaControl(dataManager: dataManager),
          ),
        ),
      ),
    );
  }
}
