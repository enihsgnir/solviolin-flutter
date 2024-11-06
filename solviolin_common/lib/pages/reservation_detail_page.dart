import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/regular_schedule_list_provider.dart';
import 'package:solviolin_common/providers/reservation_list_provider.dart';
import 'package:solviolin_common/utils/theme.dart';
import 'package:solviolin_common/widgets/regular_schedule_list_tile.dart';
import 'package:solviolin_common/widgets/reservation_list_tile.dart';
import 'package:solviolin_common/widgets/status_widget.dart';

class ReservationDetailPage extends ConsumerWidget {
  final int reservationID;

  const ReservationDetailPage({
    super.key,
    required this.reservationID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationList = ref.watch(reservationListProvider).requireValue;
    final reservation =
        reservationList.firstWhere((e) => e.id == reservationID);

    final userID = reservation.userID;

    final regularScheduleList = ref.watch(regularScheduleListProvider(userID));
    final regularScheduleInfo = regularScheduleList.when(
      data: (data) {
        if (data == null || data.isEmpty) {
          return const EmptyStatusWidget(
            title: "정기 스케줄이 없습니다",
          );
        }

        final regularSchedule =
            data.firstWhereOrNull((e) => e.id == reservation.regularID);
        if (regularSchedule == null) {
          return const EmptyStatusWidget(
            title: "해당하는 정기 스케줄을 찾을 수 없습니다",
          );
        }

        return RegularScheduleListTile(
          regularSchedule,
          isForAdmin: true,
          shouldPopAfterAction: true,
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "정기 스케줄을 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("수업 관리"),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          const SizedBox(height: 24),
          Text("${reservation.branchName} $userID", style: titleLarge),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 24),
          const Text("수업 정보", style: titleLarge),
          const SizedBox(height: 12),
          ReservationListTile(
            reservation,
            isForAdmin: true,
            shouldPopAfterAction: true,
          ),
          const Divider(),
          const SizedBox(height: 24),
          const Text("정기 스케줄 정보", style: titleLarge),
          const SizedBox(height: 12),
          regularScheduleInfo,
        ],
      ),
    );
  }
}
