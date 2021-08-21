import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solviolin/util/data_source.dart';
import 'package:solviolin/view/main/calendar_reserved.dart';
import 'package:solviolin/view/main/grid_available.dart';
import 'package:solviolin/view/main/my_reservation.dart';
import 'package:solviolin/view/main/user_profile.dart';

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
            Padding(
              padding: EdgeInsets.fromLTRB(8.r, 16.r, 8.r, 0),
              child: UserProfile(),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(8.r, 8.r, 8.r, 0),
              color: Colors.grey,
              height: 0.5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.r),
              child: CalendarReserved(),
            ),
            Container(
              margin: EdgeInsets.all(8.r),
              color: Colors.grey,
              height: 0.5,
            ),
            MyReservation(),
            GridAvailable(),
          ],
        ),
      ),
    );
  }
}
