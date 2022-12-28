import 'package:flutter/material.dart';
import 'package:solviolin/util/constant.dart';
import 'package:solviolin/view/make_up/calendar_reserved.dart';
import 'package:solviolin/view/make_up/grid_available.dart';
import 'package:solviolin/view/make_up/reservation_card.dart';
import 'package:solviolin/widget/single.dart';

class MakeUpPage extends StatefulWidget {
  const MakeUpPage({Key? key}) : super(key: key);

  @override
  _MakeUpPageState createState() => _MakeUpPageState();
}

class _MakeUpPageState extends State<MakeUpPage> {
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
            ReservationCard(),
            GridAvailable(),
          ],
        ),
      ),
    );
  }
}
