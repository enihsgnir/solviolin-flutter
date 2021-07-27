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
  List<int> _tempos = []
    ..addAll(List.generate(10, (index) => 40 + 2 * index))
    ..addAll(List.generate(4, (index) => 60 + 3 * index))
    ..addAll(List.generate(12, (index) => 72 + 4 * index))
    ..addAll(List.generate(4, (index) => 120 + 6 * index))
    ..addAll(List.generate(9, (index) => 144 + 8 * index));

  bool _isPlaying = false;
  late Metronome _metronome;
  StreamSubscription<DateTime>? _subscription;
  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    _metronome = Metronome.epoch(
        Duration(microseconds: (60 * 1000 * 1000 / _tempos[_index]).round()));
    assetsAudioPlayer.open(Audio("assets/metronome_sound_sample.mp3"));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width -
        (MediaQuery.of(context).padding.left +
            MediaQuery.of(context).padding.right);
    final _deviceHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom);
    final _textHeight = _deviceHeight / MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${_tempos[_index]}",
            style: TextStyle(fontSize: 75),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: _deviceWidth * 0.1,
                    height: _deviceHeight * 0.05,
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  onTap: () => _count("-"),
                  enableFeedback: false,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: _deviceWidth * 0.25,
                    height: _deviceHeight * 0.05,
                    child: const Text(
                      "Select",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: _select,
                  enableFeedback: false,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: _deviceWidth * 0.1,
                    height: _deviceHeight * 0.05,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  onTap: () => _count("+"),
                  enableFeedback: false,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(5),
                ),
                width: _deviceWidth * 0.2,
                height: _deviceHeight * 0.05,
                child: Text(
                  _isPlaying ? "Stop" : "Start",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: _play,
              enableFeedback: false,
            ),
          ),
        ],
      ),
    );
  }

  void _play() async {
    setState(() {
      if (_isPlaying) {
        _subscription?.cancel();
        _isPlaying = false;
      } else {
        _subscription = _metronome.listen((event) => assetsAudioPlayer.play());
        // _subscription = _metronome
        //     .listen((event) => SystemSound.play(SystemSoundType.click));
        _isPlaying = true;
      }
    });
  }

  void _count(String sign) {
    if (_isPlaying) {
      _subscription?.cancel();
      _isPlaying = false;
    }

    if (sign == "+" && _index < _tempos.length) {
      setState(() {
        _index++;
      });
    } else if (sign == "-" && _index > 0) {
      setState(() {
        _index--;
      });
    }
    setState(() {
      _metronome = Metronome.epoch(
          Duration(microseconds: (60 * 1000 * 1000 / _tempos[_index]).round()));
    });
  }

  void _select() async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(initialItem: _index),
            itemExtent: _tempos.length.toDouble(),
            onSelectedItemChanged: (index) {
              setState(() {
                _index = index;
                _metronome = Metronome.epoch(Duration(
                    microseconds:
                        (60 * 1000 * 1000 / _tempos[_index]).round()));
              });

              if (_isPlaying) {
                _subscription?.cancel();
                _isPlaying = false;
              }
            },
            children: List.generate(
              _tempos.length,
              (index) => Text("${_tempos[index]}",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 40,
                  )),
            ),
          ),
        );
      },
    );
  }
}
