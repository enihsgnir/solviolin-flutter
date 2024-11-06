import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/extensions/date_time_extension.dart';
import 'package:solviolin_common/models/regular_schedule.dart';
import 'package:solviolin_common/providers/available_spots_provider.dart';
import 'package:solviolin_common/providers/selected_day_provider.dart';
import 'package:solviolin_common/providers/term_range_provider.dart';
import 'package:solviolin_common/widgets/make_up_available_spot_button.dart';
import 'package:solviolin_common/widgets/status_widget.dart';

class MakeUpAvailableSpotButtonGrid extends ConsumerWidget {
  final RegularSchedule regularSchedule;

  const MakeUpAvailableSpotButtonGrid({
    super.key,
    required this.regularSchedule,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now().dateOnly;

    final selectedDay = ref.watch(selectedDayProvider);
    if (selectedDay.isBefore(today)) {
      return const EmptyStatusWidget(
        title: "지난 날짜의 수업은 예약할 수 없습니다",
        subtitle: "다른 날짜를 선택해주세요",
      );
    }

    final termRange = ref.watch(termRangeProvider).valueOrNull;
    if (termRange == null || selectedDay.isAfter(termRange.current.termEnd)) {
      return const EmptyStatusWidget(
        title: "다음 학기의 수업 예약은 해당 학기에 가능합니다",
        subtitle: "다른 날짜를 선택해주세요",
      );
    }

    // unwrap previous value to show loading status while fetching new data
    final availableSpots =
        ref.watch(availableSpotsProvider(regularSchedule)).unwrapPrevious();
    return availableSpots.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyStatusWidget(
            title: "예약가능한 시간대가 없습니다",
            subtitle: "다른 날짜를 선택해주세요",
          );
        }

        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 8,
          childAspectRatio: 2,
          children: [
            for (final spot in data)
              MakeUpAvailableSpotButton(
                regularSchedule: regularSchedule,
                spot: spot,
              ),
          ],
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "예약가능한 시간대를 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );
  }
}
