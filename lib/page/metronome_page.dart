import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  final player = Get.put(AudioCache());

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
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(CupertinoIcons.arrow_left, size: 28),
        ),
        title: Text("메트로놈", style: TextStyle(fontSize: 28)),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            height: deviceHeight * 0.15,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            width: deviceWidth * 0.4,
            height: deviceWidth * 0.2,
            child: Text(
              "Tempo",
              style: TextStyle(
                color: Colors.white,
                fontSize: deviceWidth * 0.1,
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
                    width: deviceWidth * 0.15,
                    height: deviceWidth * 0.15,
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: deviceWidth * 0.1,
                    ),
                  ),
                  onTap: () => count(false),
                  enableFeedback: false,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: deviceWidth * 0.4,
                height: deviceWidth * 0.3,
                child: InkWell(
                  child: Text(
                    "${tempos[_index]}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: deviceWidth * 0.2,
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
                    width: deviceWidth * 0.15,
                    height: deviceWidth * 0.15,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: deviceWidth * 0.1,
                    ),
                  ),
                  onTap: () => count(true),
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
                width: deviceWidth * 0.4,
                height: deviceWidth * 0.4,
                child: Icon(
                  isPlaying
                      ? Icons.pause_circle_outline_rounded
                      : Icons.play_circle_outline_rounded,
                  size: deviceWidth * 0.3,
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

  void count(bool sign) {
    setState(() {
      if (isPlaying) {
        subscription?.cancel();
        isPlaying = false;
      }

      if (sign == true && _index < tempos.length - 1) {
        _index++;
      } else if (sign == false && _index > 0) {
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
        final deviceHeight = MediaQuery.of(context).size.height;

        return Container(
          height: deviceHeight * 0.35,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: _index),
            itemExtent: deviceHeight * 0.046,
            onSelectedItemChanged: (index) => setState(() {
              if (isPlaying) {
                subscription?.cancel();
                isPlaying = false;
              }
              _index = index;
              metronome = Metronome.epoch(Duration(
                  microseconds: (60 * 1000 * 1000 / tempos[_index]).round()));
            }),
            children: List<Container>.generate(
              tempos.length,
              (index) => Container(
                alignment: Alignment.center,
                child: Text(
                  "${tempos[index]}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: deviceHeight * 0.032,
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
