import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solviolin/widget/calendar_reserved.dart';
import 'package:solviolin/widget/grid_available.dart';
import 'package:solviolin/widget/my_reservation.dart';
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
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
              child: UserProfile(),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              color: Colors.grey,
              height: 0.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CalendarReserved(),
            ),
            Container(
              margin: const EdgeInsets.all(8),
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
