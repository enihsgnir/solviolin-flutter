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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: UserProfile(),
            ),
            Container(
              margin: EdgeInsets.all(5),
              color: Colors.grey,
              height: 0.5,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: CalendarReserved(),
            ),
            Container(
              margin: EdgeInsets.all(5),
              color: Colors.grey,
              height: 0.5,
            ),
            ReservationGrid(),
          ],
        ),
      ),
    );
  }
}
