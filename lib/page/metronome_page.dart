import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quiver/async.dart';

class MetronomePage extends StatefulWidget {
  const MetronomePage({Key? key}) : super(key: key);

  @override
  _MetronomePageState createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> {
  late Metronome metronome;
  StreamSubscription<DateTime>? subscription;
  bool isPlaying = false;

  int _index = 21;
  List<int> tempos = []
    ..addAll(List.generate(10, (index) => 40 + 2 * index))
    ..addAll(List.generate(4, (index) => 60 + 3 * index))
    ..addAll(List.generate(12, (index) => 72 + 4 * index))
    ..addAll(List.generate(4, (index) => 120 + 6 * index))
    ..addAll(List.generate(9, (index) => 144 + 8 * index));

  final AudioCache player = Get.put(AudioCache());

  @override
  void initState() {
    super.initState();
    metronome = Metronome.epoch(
        Duration(microseconds: (60 * 1000 * 1000 / tempos[_index]).round()));
    player.load("metronome_sound_sample.mp3");
  }

  @override
  void dispose() {
    subscription?.cancel();
    player.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(CupertinoIcons.chevron_left, size: 28.r),
        ),
        title: Text("메트로놈", style: TextStyle(fontSize: 28.sp)),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            height: 172.h,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            width: 216.r,
            height: 108.r,
            child: Text(
              "Tempo",
              style: TextStyle(
                color: Colors.white,
                fontSize: 54.sp,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(96, 128, 104, 100),
                      shape: BoxShape.circle,
                    ),
                    width: 81.r,
                    height: 81.r,
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 54.r,
                    ),
                  ),
                  onTap: () => count(CountType.decrease),
                  enableFeedback: false,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 216.r,
                height: 162.r,
                child: InkWell(
                  child: Text(
                    "${tempos[_index]}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 108.sp,
                    ),
                  ),
                  onTap: select,
                  enableFeedback: false,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(96, 128, 104, 100),
                      shape: BoxShape.circle,
                    ),
                    width: 81.r,
                    height: 81.r,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 54.r,
                    ),
                  ),
                  onTap: () => count(CountType.increase),
                  enableFeedback: false,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              child: Container(
                alignment: Alignment.center,
                width: 216.r,
                height: 216.r,
                child: Icon(
                  isPlaying
                      ? Icons.pause_circle_outline_rounded
                      : Icons.play_circle_outline_rounded,
                  size: 162.r,
                ),
              ),
              onTap: play,
              enableFeedback: false,
            ),
          ),
        ],
      ),
    );
  }

  void play() async {
    setState(() {
      if (isPlaying) {
        subscription?.cancel();
        isPlaying = false;
      } else {
        subscription = metronome
            .listen((event) => player.play("metronome_sound_sample.mp3"));
        isPlaying = true;
      }
    });
  }

  void count(CountType type) {
    setState(() {
      if (isPlaying) {
        subscription?.cancel();
        isPlaying = false;
      }

      if (type == CountType.increase && _index < tempos.length - 1) {
        _index++;
      } else if (type == CountType.decrease && _index > 0) {
        _index--;
      }
      metronome = Metronome.epoch(
          Duration(microseconds: (60 * 1000 * 1000 / tempos[_index]).round()));
    });
  }

  Future select() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 400.h,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: _index),
            itemExtent: 52.h,
            onSelectedItemChanged: (index) {
              setState(() {
                if (isPlaying) {
                  subscription?.cancel();
                  isPlaying = false;
                }
                _index = index;
                metronome = Metronome.epoch(Duration(
                    microseconds: (60 * 1000 * 1000 / tempos[_index]).round()));
              });
            },
            children: List<Container>.generate(
              tempos.length,
              (index) => Container(
                alignment: Alignment.center,
                child: Text(
                  "${tempos[index]}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.sp,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

enum CountType {
  increase,
  decrease,
}
