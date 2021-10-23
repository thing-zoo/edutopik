import 'dart:async';
import 'package:edutopik/constants.dart';
import 'package:edutopik/screens/media/data_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:volume_control/volume_control.dart';

class MediaControl extends StatefulWidget {
  MediaControl({Key? key, this.dataManager}) : super(key: key);
  final DataManager? dataManager;

  @override
  State<MediaControl> createState() => _MediaControlState();
}

class _MediaControlState extends State<MediaControl> {
  final double iconSize = 30;
  final double fontSize = 14;
  double _playBackSpeed = 1.0;
  double _volume = 0.5;
  double _brightness = 0.5;

  @override
  void initState() {
    super.initState();
    initScreenBrightness();
    initVolumeState();
  }

  //init screen_brightness plugin
  Future<void> initScreenBrightness() async {
    double _initBrightness;

    try {
      final currentBrightness = await ScreenBrightness.current;
      final initialBrightness = await ScreenBrightness.initial;
      _initBrightness = initialBrightness == currentBrightness
          ? initialBrightness
          : currentBrightness;
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to get initial brightness';
    }

    if (!mounted) return;

    setState(() {
      _brightness = _initBrightness;
    });
  }

  Future<void> setBrightness(double brightness) async {
    try {
      await ScreenBrightness.setScreenBrightness(brightness);
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to set brightness';
    }
  }

  //init volume_control plugin
  Future<void> initVolumeState() async {
    if (!mounted) return;

    //read the current volume
    _volume = await VolumeControl.volume;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FlickVideoManager flickVideoManager =
        Provider.of<FlickVideoManager>(context);

    return Stack(
      children: <Widget>[
        //아이콘 보이도록 투명한 검은 뒷배경
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Container(color: Colors.black38),
          ),
        ),

        /* 중앙부분 */
        Positioned(
          child: FlickShowControlsAction(
            /* 뒤로,빨리감기 */
            child: FlickSeekVideoAction(
              child: Center(
                child: flickVideoManager.nextVideoAutoPlayTimer != null
                    ? FlickAutoPlayCircularProgress(
                        /* 로딩 */
                        colors: FlickAutoPlayTimerProgressColors(
                          backgroundColor: Colors.white30,
                          color: kPrimaryColor,
                        ),
                      )
                    : FlickVideoBuffer(
                        /* 재생 */
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

        /* 하단부분 */
        Positioned.fill(
          bottom: 20,
          child: FlickAutoHideChild(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                /* 재생바 */
                FlickVideoProgressBar(
                  flickProgressBarSettings: FlickProgressBarSettings(
                    height: 5,
                    handleRadius: 6,
                    curveRadius: 50,
                    backgroundColor: Colors.white24,
                    bufferedColor: Colors.white38,
                    playedColor: kPrimaryColor,
                    handleColor: kPrimaryColor,
                  ),
                ),
                /* 시간, 배속, 이동 */
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    /* 시간, 배속 */
                    Row(
                      children: <Widget>[
                        /* 현재시간/전체시간 */
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
                        /* 배속 조절 */
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_playBackSpeed <= 0.5)
                                _playBackSpeed = 0.5;
                              else
                                _playBackSpeed -= 0.25;
                              flickVideoManager.videoPlayerController
                                  ?.setPlaybackSpeed(_playBackSpeed);
                            });
                          },
                          child: Icon(
                            Icons.remove,
                            size: iconSize * 0.8,
                          ),
                        ),
                        Text(
                          _playBackSpeed.toStringAsFixed(2) + "x",
                          style: TextStyle(
                            fontSize: fontSize,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (_playBackSpeed >= 2.0)
                                _playBackSpeed = 2.0;
                              else
                                _playBackSpeed += 0.25;
                              flickVideoManager.videoPlayerController
                                  ?.setPlaybackSpeed(_playBackSpeed);
                            });
                          },
                          child: Icon(
                            Icons.add,
                            size: iconSize * 0.8,
                          ),
                        ),
                      ],
                    ),
                    /* 강의 이동 */
                    Row(
                      children: [
                        /* 이전강의로 */
                        GestureDetector(
                          onTap: () {
                            widget.dataManager!.skipToPreviousVideo();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.skip_previous,
                                color: widget.dataManager!.hasPreviousVideo()
                                    ? Colors.white
                                    : Colors.white38,
                                size: iconSize,
                              ),
                              Text(
                                '이전 강의',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: widget.dataManager!.hasPreviousVideo()
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
                        /* 다음강의로 */
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
                              Text(
                                '다음 강의',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: widget.dataManager!.hasNextVideo()
                                      ? Colors.white
                                      : Colors.white38,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        /* 소리 조절 */
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SfSlider.vertical(
                      value: _volume,
                      onChanged: (dynamic newValue) async {
                        await VolumeControl.setVolume(newValue);
                        setState(() {
                          _volume = newValue;
                        });
                      },
                      activeColor: kPrimaryColor,
                      inactiveColor: Colors.white54,
                      thumbIcon: Icon(Icons.volume_up),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        /* 밝기 조절 */
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SfSlider.vertical(
                      value: _brightness,
                      onChanged: (dynamic value) async {
                        await setBrightness(value);
                        setState(() {
                          _brightness = value;
                        });
                      },
                      activeColor: kPrimaryColor,
                      inactiveColor: Colors.white54,
                      thumbIcon: Icon(Icons.light_mode),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        /* 상단 부분 */
        Positioned.fill(
          top: 20,
          child: FlickAutoHideChild(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    /* 뒤로가기 */
                    GestureDetector(
                      onTap: () {
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
                    /* 강의 제목 */
                    Text(
                      '[TOPIK] 1강. 강의 소개',
                      /* 백엔드: 여기에 이름 가져와서 넣도록~ */
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
