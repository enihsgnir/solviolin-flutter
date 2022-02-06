import 'package:flutter/material.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/view/main/calendar_reserved.dart';
import 'package:solviolin/view/main/grid_available.dart';
import 'package:solviolin/view/main/my_reservation.dart';
import 'package:solviolin/widget/single.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("수업변경"),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.r),
              child: CalendarReserved(),
            ),
            myDivider(),
            MyReservation(),
            GridAvailable(),
          ],
        ),
      ),
    );
  }
}
