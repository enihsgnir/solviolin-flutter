import 'package:flutter/material.dart';

class MetronomePage extends StatefulWidget {
  const MetronomePage({Key? key}) : super(key: key);

  @override
  _MetronomePageState createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue.shade100,
        child: Text(
          "Metronome\nPage",
          style: TextStyle(
            fontSize: 75,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
