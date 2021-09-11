import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiver/async.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/widget/single.dart';

class MetronomePage extends StatefulWidget {
  const MetronomePage({Key? key}) : super(key: key);

  @override
  _MetronomePageState createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> {
  late Metronome metronome;
  StreamSubscription<DateTime>? subscription;

  final player = Get.put(AudioCache());

  var _index = 21;
  List<int> tempos = []
    ..addAll(List.generate(10, (index) => 40 + 2 * index))
    ..addAll(List.generate(4, (index) => 60 + 3 * index))
    ..addAll(List.generate(12, (index) => 72 + 4 * index))
    ..addAll(List.generate(4, (index) => 120 + 6 * index))
    ..addAll(List.generate(9, (index) => 144 + 8 * index));

  var _isPlaying = false;

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
      appBar: myAppBar("메트로놈"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            alignment: Alignment.center,
            width: 220.r,
            height: 110.r,
            child: Text(
              "Tempo",
              style: TextStyle(color: Colors.white, fontSize: 54.r),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _count(CountType.decrease),
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
                width: 220.r,
                height: 160.r,
                child: InkWell(
                  child: Text(
                    "${tempos[_index]}",
                    style: TextStyle(color: Colors.white, fontSize: 108.r),
                  ),
                  onTap: _select,
                  borderRadius: BorderRadius.circular(15.r),
                  enableFeedback: false,
                ),
              ),
              ElevatedButton(
                onPressed: () => _count(CountType.increase),
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
              onPressed: _play,
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                shape: CircleBorder(),
                enableFeedback: false,
              ),
              child: Icon(
                _isPlaying
                    ? Icons.pause_circle_outline_rounded
                    : Icons.play_circle_outline_rounded,
                size: 160.r,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _play() {
    setState(() {
      if (_isPlaying) {
        subscription?.cancel();
        _isPlaying = false;
      } else {
        subscription = metronome
            .listen((event) => player.play("metronome_sound_sample.mp3"));
        _isPlaying = true;
      }
    });
  }

  void _count(CountType type) {
    setState(() {
      if (_isPlaying) {
        subscription?.cancel();
        _isPlaying = false;
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

  Future _select() {
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
                if (_isPlaying) {
                  subscription?.cancel();
                  _isPlaying = false;
                }

                _index = index;
                metronome = Metronome.epoch(Duration(
                    microseconds: (60 * 1000 * 1000 / tempos[_index]).round()));
              });
            },
            children: List.generate(
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
