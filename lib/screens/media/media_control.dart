import 'dart:async';
import 'package:edutopik/constants.dart';
import 'package:edutopik/screens/media/data_manager.dart';
import 'package:edutopik/screens/media/play_time.dart';
import 'package:edutopik/screens/test_http.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:volume_control/volume_control.dart';

class MediaControl extends StatefulWidget {
  MediaControl({
    Key? key,
    this.dataManager,
    this.flickVideoManager,
    required this.playTime,
    required this.titles,
  }) : super(key: key);
  DataManager? dataManager;
  FlickVideoManager? flickVideoManager;
  PlayTime playTime;
  List<String> titles;

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
    initPlayer();
  }

  //플레이어 초기화
  Future<void> initPlayer() async {
    //시청기록, 강의수강여부 가져오기
    widget.playTime = await setPlayTime(widget.playTime);
    //이어보기
    int time = widget.playTime.current_time;
    Duration position = Duration(hours: time ~/ 60, minutes: time % 60);
    widget.flickVideoManager?.videoPlayerController?.seekTo(position);
    setState(() {
      //속도 유지
      widget.flickVideoManager?.videoPlayerController
          ?.setPlaybackSpeed(_playBackSpeed);
    });
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

    _brightness = _initBrightness;
  }

  //init volume_control plugin
  Future<void> initVolumeState() async {
    if (!mounted) return;

    //read the current volume
    _volume = await VolumeControl.volume;
  }

  Future<void> setBrightness(double brightness) async {
    //시스템 밝기 설정
    try {
      await ScreenBrightness.setScreenBrightness(brightness);
    } catch (e) {
      debugPrint(e.toString());
      throw 'Failed to set brightness';
    }
    //위젯내 변수값 설정
    setState(() {
      _brightness = brightness;
    });
  }

  Future<void> setVolume(double volume) async {
    //시스템 볼륨 설정
    await VolumeControl.setVolume(volume);
    //위젯내 변수값 설정
    setState(() {
      _volume = volume;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                child: widget.flickVideoManager?.nextVideoAutoPlayTimer != null
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
                              widget.flickVideoManager?.videoPlayerController
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
                              widget.flickVideoManager?.videoPlayerController
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
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              //현재 위치 가져오기
                              widget.playTime.current_time = widget
                                  .flickVideoManager
                                  ?.videoPlayerValue
                                  ?.position
                                  .inMinutes;
                              //데이터 보내기
                              sendPlayTime(
                                widget.playTime.send_url,
                                widget.playTime.uid,
                                widget.playTime.ocode,
                                widget.playTime.scode,
                                widget.playTime.lm_num,
                                widget.playTime.uuid,
                                widget.playTime.current_time,
                                'N',
                              );
                              //강의 이동 후 데이터 가져오기
                              widget.playTime.lm_num--;
                              widget.dataManager?.skipToPreviousVideo();
                              initPlayer();
                            });
                          },
                          icon: Icon(
                            Icons.skip_previous,
                            color: widget.dataManager!.hasPreviousVideo()
                                ? Colors.white
                                : Colors.white38,
                            size: iconSize,
                          ),
                          label: Text(
                            '이전 강의',
                            style: TextStyle(
                              fontSize: fontSize,
                              color: widget.dataManager!.hasPreviousVideo()
                                  ? Colors.white
                                  : Colors.white38,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: iconSize / 2,
                        ),
                        /* 다음강의로 */
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              //현재 위치 가져오기
                              widget.playTime.current_time = widget
                                  .flickVideoManager
                                  ?.videoPlayerValue
                                  ?.position
                                  .inMinutes;
                              //데이터 보내기
                              print(widget.playTime.current_time);
                              sendPlayTime(
                                widget.playTime.send_url,
                                widget.playTime.uid,
                                widget.playTime.ocode,
                                widget.playTime.scode,
                                widget.playTime.lm_num,
                                widget.playTime.uuid,
                                widget.playTime.current_time,
                                'N',
                              );
                              //강의 이동 후 데이터 가져오기
                              widget.playTime.lm_num++;
                              widget.dataManager?.skipToNextVideo();
                              initPlayer();
                            });
                          },
                          icon: Icon(
                            Icons.skip_next,
                            color: widget.dataManager!.hasNextVideo()
                                ? Colors.white
                                : Colors.white38,
                            size: iconSize,
                          ),
                          label: Text(
                            '다음 강의',
                            style: TextStyle(
                              fontSize: fontSize,
                              color: widget.dataManager!.hasNextVideo()
                                  ? Colors.white
                                  : Colors.white38,
                            ),
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
                        await setVolume(newValue);
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
                      onChanged: (dynamic newValue) async {
                        await setBrightness(newValue);
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
                        //상태바&네비게이션바 보이게
                        SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.manual,
                          overlays: [
                            SystemUiOverlay.top,
                            SystemUiOverlay.bottom
                          ],
                        );
                        //세로 모드
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]);

                        //현재 위치 가져오기
                        widget.playTime.current_time = widget.flickVideoManager
                            ?.videoPlayerValue?.position.inMinutes;
                        //데이터 보내기
                        sendPlayTime(
                          widget.playTime.send_url,
                          widget.playTime.uid,
                          widget.playTime.ocode,
                          widget.playTime.scode,
                          widget.playTime.lm_num,
                          widget.playTime.uuid,
                          widget.playTime.current_time,
                          'Y', //종료했음!
                        );
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
                      // '[TOPIK] 1강. 강의 소개',
                      widget.titles[widget.playTime.lm_num - 1],
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

//서버로 데이터 보내기
Future sendPlayTime(
    url, uid, ocode, scode, lm_num, uuid, current_time, fin) async {
  final Map<String, dynamic> res = await new Session().get(
      '$url?uid=$uid&ocode=$ocode&scode=$scode&lm_num=$lm_num&uuid=$uuid&current_time=$current_time&fin=$fin');
  print(res);
}

//서버에서 데이터 가져오기
Future getPlayTime(timeUrl, uid, ocode, scode, lm_num) async {
  final Map<String, dynamic> res = await new Session()
      .get('$timeUrl?uid=$uid&ocode=$ocode&scode=$scode&lm_num=$lm_num');
  print(res);
  return res;
}

//서버에서 가져온 데이터 변수에 넣기
Future<PlayTime> setPlayTime(PlayTime playTime) async {
  //현재 시청 지점 가져오기
  final Map<String, dynamic> res = await getPlayTime(
    playTime.get_time_url,
    playTime.uid,
    playTime.ocode,
    playTime.scode,
    playTime.lm_num,
  );
  playTime.current_time = int.parse(res['current_time']);
  playTime.fin = res['fin'];

  return playTime;
}
