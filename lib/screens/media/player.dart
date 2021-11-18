import 'package:edutopik/screens/media/media_control.dart';
// import 'package:edutopik/models/mock_data.dart'; //임시로 아무데나 만듦
import 'package:edutopik/screens/media/data_manager.dart';
import 'package:edutopik/screens/media/play_time.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {
  Player(
      {Key? key,
      required this.urls,
      required this.titles,
      required this.playTime})
      : super(key: key);
  List<String> urls;
  List<String> titles;
  PlayTime playTime;

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late FlickManager flickManager;
  late DataManager dataManager;

  /* 테스트용 링크 */
  // List<String> urls = (mockData["items"] as List)
  //     .map<String>((item) => item["trailer_url"])
  //     .toList();

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(
          widget.urls[widget.playTime.lm_num - 1],
          // urls[0], /* 테스트용 링크 */
        ),
        onVideoEnd: () {
          dataManager.skipToNextVideo(Duration(seconds: 5));
        });

    dataManager = DataManager(
      flickManager: flickManager,
      urls: widget.urls,
      currentPlaying: widget.playTime.lm_num - 1,
    );
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
            videoFit: BoxFit.fitWidth, //영상을 safearea에 맞게
            controls: MediaControl(
              dataManager: dataManager,
              playTime: widget.playTime,
              flickVideoManager: flickManager.flickVideoManager,
              titles: widget.titles,
            ),
          ),
        ),
      ),
    );
  }
}
