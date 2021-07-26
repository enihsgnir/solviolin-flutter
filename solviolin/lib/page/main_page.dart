import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:solviolin/widget/calendar_reserved.dart';
import 'package:solviolin/widget/timeslot_reserved.dart';
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
    final _deviceWidth = MediaQuery.of(context).size.width -
        (MediaQuery.of(context).padding.left +
            MediaQuery.of(context).padding.right);
    final _deviceHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom);
    return Scaffold(
      body: SafeArea(
        child: SlidingUpPanel(
          minHeight: _deviceHeight * 0.44,
          maxHeight: _deviceHeight * 0.84,
          backdropEnabled: true,
          color: Theme.of(context).backgroundColor,
          panel: Column(
            children: [
              Container(
                width: _deviceWidth,
                height: _deviceHeight * 0.02,
                color: Colors.black87,
                child: Icon(
                  CupertinoIcons.chevron_compact_down,
                  size: _deviceHeight * 0.02,
                ),
              ),
              TimeslotReserved(stream: _streamController.stream),
            ],
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(5, _deviceHeight * 0.005, 5, 0),
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
