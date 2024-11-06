import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/regular_schedule_list_provider.dart';
import 'package:solviolin_common/utils/env.dart';
import 'package:solviolin_common/widgets/make_up_available_spot_button_grid.dart';
import 'package:solviolin_common/widgets/status_widget.dart';

class MakeUpAvailableSpots extends ConsumerWidget {
  const MakeUpAvailableSpots({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regularScheduleList = ref.watch(regularScheduleListProvider(null));
    return regularScheduleList.when(
      data: (data) {
        if (data == null || data.isEmpty) {
          return const EmptyStatusWidget(
            title: "수업시간 변경이 필요하시면",
            subtitle: "$managerPhone로 문의바랍니다",
          );
        }

        return MakeUpAvailableSpotButtonGrid(regularSchedule: data.first);
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "정기 수업을 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );
  }
}
