import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:solviolin/widgets/metronome_bpm_button.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

const String _fileName = "metronome.mp3";

const int _minBpm = 40;
const int _maxBpm = 208;

class MetronomePage extends StatefulWidget {
  const MetronomePage({super.key});

  @override
  _MetronomePageState createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;

  final player = AudioPlayer();
  late final Ticker ticker;

  int bpm = 100;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    player.setSource(AssetSource(_fileName));
    player.setPlayerMode(PlayerMode.lowLatency);
    ticker = createTicker((elapsed) {
      const microsecondsPerMinute = 60 * 1000 * 1000;
      final delay = (microsecondsPerMinute / bpm).round();

      if (elapsed >= _elapsed + Duration(microseconds: delay)) {
        player.resume();
        _elapsed = elapsed;
      }
    });
  }

  @override
  void dispose() {
    stop();
    ticker.dispose();
    player.dispose();
    super.dispose();
  }

  void start() {
    isPlaying = true;
    _elapsed = Duration.zero;
    ticker.start();

    WakelockPlus.enable();
  }

  void stop() {
    ticker.stop();
    isPlaying = false;

    WakelockPlus.disable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("메트로놈"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("버튼을 길게 눌러 BPM을 조절하세요"),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MetronomeBpmButton(
                onPressed: () => setState(() {
                  if (isPlaying) {
                    stop();
                  }
                  bpm = max(bpm - 1, _minBpm);
                }),
                child: const Icon(
                  Icons.remove_circle_outline_rounded,
                  size: 60,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 120,
                child: Text(
                  "$bpm",
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              MetronomeBpmButton(
                onPressed: () => setState(() {
                  if (isPlaying) {
                    stop();
                  }
                  bpm = min(bpm + 1, _maxBpm);
                }),
                child: const Icon(
                  Icons.add_circle_outline_rounded,
                  size: 60,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => setState(() {
              isPlaying ? stop() : start();
            }),
            child: Icon(
              isPlaying
                  ? Icons.pause_circle_outline_rounded
                  : Icons.play_circle_outline_rounded,
              size: 160,
            ),
          ),
        ],
      ),
    );
  }
}
