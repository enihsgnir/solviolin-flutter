import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solviolin/widget/calendar_reserved.dart';
import 'package:solviolin/widget/reservation_grid.dart';
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
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(5, deviceHeight * 0.005, 5, 0),
              child: UserProfile(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: CalendarReserved(streamController: streamController),
            ),
            ReservationGrid(stream: streamController.stream),
          ],
        ),
      ),
    );
  }
}
