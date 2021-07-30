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
  StreamController<DateTime> streamController = StreamController<DateTime>();

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SlidingUpPanel(
          panel: Column(
            children: [
              Container(
                width: double.infinity,
                height: deviceHeight * 0.02,
                color: Colors.black87,
                child: Icon(
                  CupertinoIcons.chevron_compact_down,
                  size: deviceHeight * 0.02,
                ),
              ),
              TimeslotReserved(stream: streamController.stream),
            ],
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(5, deviceHeight * 0.005, 5, 0),
                child: UserProfile(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: CalendarReserved(streamController: streamController),
              ),
            ],
          ),
          // collapsed: Container(
          //   color: Colors.blueGrey,
          //   child: Center(
          //     child: Text(
          //       "This is the collapsed Widget",
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),
          // ),
          minHeight: deviceHeight * 0.44,
          maxHeight: deviceHeight * 0.84,
          color: Theme.of(context).backgroundColor,
          backdropEnabled: true,
        ),
      ),
    );
  }
}
