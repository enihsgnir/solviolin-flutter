import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:solviolin/widget/table_calendar_reserved.dart';
import 'package:solviolin/widget/sf_timeslot_reserved.dart';
import 'package:solviolin/widget/user_profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  StreamController<DateTime> _streamController = StreamController<DateTime>();

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final double _statusBarHeight = MediaQuery.of(context).padding.top;
    // final double _navigationBarHeight = MediaQuery.of(context).padding.bottom;
    // print(_navigationBarHeight); // 48.0
    // print(MediaQuery.of(context).padding.top); //62.2
    // print(MediaQuery.of(context).padding.left); // 0.0
    // print(MediaQuery.of(context).padding.right); // 0.0

    return Scaffold(
      body: SafeArea(
        child: SlidingUpPanel(
          minHeight: 500,
          maxHeight: 850,
          backdropEnabled: true,
          panel: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 20,
                color: Colors.black54,
                child: Icon(
                  CupertinoIcons.chevron_compact_down,
                  size: 20,
                ),
              ),
              SfTimeslotReserved(stream: _streamController.stream),
            ],
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: UserProfile(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: CalendarReserved(streamController: _streamController),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
