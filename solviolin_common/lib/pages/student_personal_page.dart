import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:solviolin_common/models/term_position.dart';
import 'package:solviolin_common/utils/theme.dart';
import 'package:solviolin_common/widgets/user_detail_change_list.dart';
import 'package:solviolin_common/widgets/user_detail_regular_schedule_list.dart';
import 'package:solviolin_common/widgets/user_detail_reservation_list.dart';

class StudentPersonalPage extends HookWidget {
  const StudentPersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTabController(initialLength: 3, initialIndex: 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("내 예약"),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return const [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
                    child: Text("내 정기 수업", style: titleLarge),
                  ),
                  UserDetailRegularScheduleList(userID: null),
                  Divider(),
                ],
              ),
            ),
          ];
        },
        body: Column(
          children: [
            TabBar(
              controller: controller,
              tabs: const [
                Tab(child: Text("지난 학기")),
                Tab(child: Text("이번 학기")),
                Tab(child: Text("변경 내역")),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: controller,
                children: const [
                  UserDetailReservationList(
                    user: null,
                    position: TermPosition.previous,
                  ),
                  UserDetailReservationList(
                    user: null,
                    position: TermPosition.current,
                  ),
                  UserDetailChangeList(userID: null),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
