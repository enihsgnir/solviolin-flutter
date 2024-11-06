import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/my_valid_reservations_provider.dart';
import 'package:solviolin_common/providers/selected_day_provider.dart';
import 'package:solviolin_common/utils/utils.dart';
import 'package:solviolin_common/widgets/reservation_list_tile.dart';
import 'package:solviolin_common/widgets/status_widget.dart';

class MakeUpReservationList extends ConsumerWidget {
  const MakeUpReservationList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);

    final validReservations = ref.watch(myValidReservationsProvider);
    return validReservations.when(
      data: (data) {
        final reservations =
            data.where((e) => isSameDay(e.startDate, selectedDay)).toList();
        if (reservations.isEmpty) {
          return const EmptyStatusWidget(
            title: "예약된 수업이 없습니다",
            subtitle: "다른 날짜를 선택해주세요",
          );
        }

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: reservations.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) =>
              ReservationListTile(reservations[index], showActions: false),
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "수업을 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );
  }
}
