import 'package:edutopik/constants.dart';
import 'package:edutopik/model/media_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MediaControls extends StatefulWidget {
  MediaControls({Key? key, this.dataManager}) : super(key: key);
  final DataManager? dataManager;

  @override
  State<MediaControls> createState() => _MediaControlsState();
}

class _MediaControlsState extends State<MediaControls> {
  final double iconSize = 30;
  final double fontSize = 14;
  double playBackSpeed = 1.0;
  @override
  Widget build(BuildContext context) {
    FlickVideoManager flickVideoManager =
        Provider.of<FlickVideoManager>(context);

    return Stack(
      children: <Widget>[
        Positioned.fill(
          //아이콘 보이도록 투명한 검은 뒷배경
          child: FlickAutoHideChild(
            child: Container(color: Colors.black38),
          ),
        ),
        Positioned.fill(
            child: FlickAutoHideChild(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      //뒤로가기
                      onTap: () {
                        // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                        SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.manual);
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]);
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: iconSize * 0.8,
                      ),
                    ),
                    SizedBox(
                      width: iconSize / 2,
                    ),
                    Text(
                      //강의 제목
                      '[TOPIK] 1강. 강의 소개',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )),
        Positioned.fill(
          child: FlickShowControlsAction(
            child: FlickSeekVideoAction(
              //뒤로,빨리감기
              child: Center(
                child: flickVideoManager.nextVideoAutoPlayTimer != null
                    ? FlickAutoPlayCircularProgress(
                        //로딩
                        colors: FlickAutoPlayTimerProgressColors(
                          backgroundColor: Colors.white30,
                          color: kPrimaryColor,
                        ),
                      )
                    : FlickVideoBuffer(
                        //재생
                        child: FlickAutoHideChild(
                          showIfVideoNotInitialized: false,
                          child: FlickPlayToggle(
                            size: iconSize,
                            color: Colors.black,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlickVideoProgressBar(
                    //재생바
                    flickProgressBarSettings: FlickProgressBarSettings(
                      height: 5,
                      handleRadius: 5,
                      curveRadius: 50,
                      backgroundColor: Colors.white24,
                      bufferedColor: Colors.white38,
                      playedColor: kPrimaryColor,
                      handleColor: kPrimaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          //시청시간, 전체시간
                          children: <Widget>[
                            FlickCurrentPosition(
                              fontSize: fontSize,
                            ),
                            Text(
                              ' / ',
                              style: TextStyle(
                                  color: Colors.white, fontSize: fontSize),
                            ),
                            FlickTotalDuration(
                              fontSize: fontSize,
                            ),
                            SizedBox(
                              width: iconSize / 2,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (playBackSpeed <= 0.5)
                                  playBackSpeed = 0.5;
                                else
                                  playBackSpeed -= 0.25;
                                flickVideoManager.videoPlayerController
                                    ?.setPlaybackSpeed(playBackSpeed);
                              },
                              child: Icon(
                                Icons.remove,
                                size: iconSize * 0.8,
                              ),
                            ),
                            Text(
                              playBackSpeed.toStringAsFixed(2) + "x",
                              style: TextStyle(
                                fontSize: fontSize,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (playBackSpeed >= 2.0)
                                  playBackSpeed = 2.0;
                                else
                                  playBackSpeed += 0.25;
                                flickVideoManager.videoPlayerController
                                    ?.setPlaybackSpeed(playBackSpeed);
                              },
                              child: Icon(
                                Icons.add,
                                size: iconSize * 0.8,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.dataManager!.skipToPreviousVideo();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.skip_previous,
                                    color:
                                        widget.dataManager!.hasPreviousVideo()
                                            ? Colors.white
                                            : Colors.white38,
                                    size: iconSize,
                                  ),
                                  Text(
                                    '이전 강의',
                                    style: TextStyle(
                                      fontSize: fontSize,
                                      color:
                                          widget.dataManager!.hasPreviousVideo()
                                              ? Colors.white
                                              : Colors.white38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: iconSize / 2,
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.dataManager!.skipToNextVideo();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.skip_next,
                                    color: widget.dataManager!.hasNextVideo()
                                        ? Colors.white
                                        : Colors.white38,
                                    size: iconSize,
                                  ),
                                  Text('다음 강의',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color:
                                            widget.dataManager!.hasNextVideo()
                                                ? Colors.white
                                                : Colors.white38,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
