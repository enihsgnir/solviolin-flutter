import 'package:flutter/material.dart';
import 'package:solviolin_common/utils/theme.dart';
import 'package:solviolin_common/widgets/make_up_available_spots.dart';
import 'package:solviolin_common/widgets/make_up_calendar.dart';
import 'package:solviolin_common/widgets/make_up_reservation_list.dart';

class StudentMakeUpPage extends StatelessWidget {
  const StudentMakeUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("수업 변경"),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: const [
          MakeUpCalendar(),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text("내 예약", style: titleLarge),
          ),
          MakeUpReservationList(),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text("보강 시간 선택", style: titleLarge),
          ),
          MakeUpAvailableSpots(),
        ],
      ),
    );
  }
}
