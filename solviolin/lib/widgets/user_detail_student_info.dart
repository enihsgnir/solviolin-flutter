import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:solviolin/models/term_position.dart';
import 'package:solviolin/models/user.dart';
import 'package:solviolin/utils/theme.dart';
import 'package:solviolin/widgets/user_detail_change_list.dart';
import 'package:solviolin/widgets/user_detail_ledger_list.dart';
import 'package:solviolin/widgets/user_detail_regular_schedule_list.dart';
import 'package:solviolin/widgets/user_detail_reservation_list.dart';

class UserDetailStudentInfo extends HookWidget {
  final User user;

  const UserDetailStudentInfo({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTabController(initialLength: 4, initialIndex: 1);

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("정기 수업 정보", style: titleLarge),
                ),
                const SizedBox(height: 12),
                UserDetailRegularScheduleList(userID: user.userID),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final uri = Uri(
                        path: "/admin/ledger/create",
                        queryParameters: {
                          "branchName": user.branchName,
                          "userID": user.userID,
                        },
                      );

                      context.push(uri.toString());
                    },
                    child: const Text("원비 납부하러 가기"),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
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
              Tab(child: Text("납부 내역")),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                UserDetailReservationList(
                  user: user,
                  position: TermPosition.previous,
                ),
                UserDetailReservationList(
                  user: user,
                  position: TermPosition.current,
                ),
                UserDetailChangeList(userID: user.userID),
                UserDetailLedgerList(userID: user.userID),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
