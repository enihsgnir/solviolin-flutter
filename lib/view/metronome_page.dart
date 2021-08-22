import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiver/async.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/widget/single_reusable.dart';

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
      appBar: appBar("메트로놈"),
      body: Column(
        children: [
          Container(
            height: 172.r,
          ),
          Container(
            padding: EdgeInsets.all(16.r),
            alignment: Alignment.center,
            width: 216.r,
            height: 108.r,
            child: Text(
              "Tempo",
              style: TextStyle(
                color: Colors.white,
                fontSize: 54.r,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => count(CountType.decrease),
                style: ElevatedButton.styleFrom(
                  primary: symbolColor,
                  shape: CircleBorder(),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Icon(Icons.remove, color: Colors.white, size: 54.r),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 216.r,
                height: 162.r,
                child: InkWell(
                  child: Text(
                    "${tempos[_index]}",
                    style: TextStyle(color: Colors.white, fontSize: 108.r),
                  ),
                  onTap: select,
                  enableFeedback: false,
                ),
              ),
              ElevatedButton(
                onPressed: () => count(CountType.increase),
                style: ElevatedButton.styleFrom(
                  primary: symbolColor,
                  shape: CircleBorder(),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Icon(Icons.add, color: Colors.white, size: 54.r),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(32.r),
            child: OutlinedButton(
              onPressed: play,
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                shape: CircleBorder(),
                enableFeedback: false,
              ),
              child: Icon(
                isPlaying
                    ? Icons.pause_circle_outline_rounded
                    : Icons.play_circle_outline_rounded,
                size: 162.r,
              ),
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
          height: 400.r,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: _index),
            itemExtent: 52.r,
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
                  style: TextStyle(color: Colors.white, fontSize: 36.r),
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
