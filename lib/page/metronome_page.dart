import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

class MetronomePage extends StatefulWidget {
  const MetronomePage({Key? key}) : super(key: key);

  @override
  _MetronomePageState createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> {
  static int _index = 21;
  List<int> tempos = []
    ..addAll(List.generate(10, (index) => 40 + 2 * index))
    ..addAll(List.generate(4, (index) => 60 + 3 * index))
    ..addAll(List.generate(12, (index) => 72 + 4 * index))
    ..addAll(List.generate(4, (index) => 120 + 6 * index))
    ..addAll(List.generate(9, (index) => 144 + 8 * index));

  late Metronome metronome;
  bool isPlaying = false;
  StreamSubscription<DateTime>? subscription;
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    metronome = Metronome.epoch(
        Duration(microseconds: (60 * 1000 * 1000 / tempos[_index]).round()));
    assetsAudioPlayer.open(Audio("assets/metronome_sound_sample.mp3"));
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${tempos[_index]}",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 120,
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
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: 72,
                    height: 72,
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                  onTap: () => count(false),
                  enableFeedback: false,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: 180,
                    height: 72,
                    child: const Text(
                      "Select",
                      style: TextStyle(color: Colors.white, fontSize: 48),
                      textAlign: TextAlign.center,
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
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: 72,
                    height: 72,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 48,
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
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: 210,
                height: 210,
                child: Text(
                  isPlaying ? "Stop" : "Start",
                  style: TextStyle(color: Colors.white, fontSize: 72),
                  textAlign: TextAlign.center,
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
        // _backgroundColor = Colors.red;
      } else {
        subscription = metronome.listen((event) => assetsAudioPlayer.play());
        // _subscription = _metronome
        //     .listen((event) => SystemSound.play(SystemSoundType.click));
        isPlaying = true;
        // _backgroundColor = Colors.green;
      }
    });
  }

  void count(bool sign) {
    setState(() {
      if (isPlaying) {
        subscription?.cancel();
        isPlaying = false;
      }

      if (sign == true && _index < tempos.length) {
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
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: _index),
            itemExtent: tempos.length.toDouble(),
            onSelectedItemChanged: (index) => setState(() {
              if (isPlaying) {
                subscription?.cancel();
                isPlaying = false;
              }
              _index = index;
              metronome = Metronome.epoch(Duration(
                  microseconds: (60 * 1000 * 1000 / tempos[_index]).round()));
            }),
            children: List.generate(
              tempos.length,
              (index) => Text(
                "${tempos[index]}",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 40,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
