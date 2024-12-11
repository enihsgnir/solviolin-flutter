import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/canceled_made_up_map_provider.dart';
import 'package:solviolin/utils/theme.dart';
import 'package:solviolin/widgets/canceled_made_up_list_tile.dart';
import 'package:solviolin/widgets/canceled_made_up_original.dart';
import 'package:solviolin/widgets/result_count.dart';
import 'package:solviolin/widgets/status_widget.dart';

class CanceledMadeUpPage extends ConsumerWidget {
  final int canceledID;

  const CanceledMadeUpPage({
    super.key,
    required this.canceledID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final madeUpMap = ref.watch(canceledMadeUpMapProvider(canceledID));

    final count = madeUpMap.maybeWhen(
      data: (data) => data.length,
      orElse: () => 0,
    );

    final child = madeUpMap.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyStatusWidget(
            title: "보강 내역이 없습니다",
            subtitle: "취소 내역을 확인해보세요",
          );
        }

        return ListView.separated(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16 + MediaQuery.of(context).padding.bottom,
          ),
          itemCount: data.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final reservation = data.values.elementAt(index);
            return CanceledMadeUpListTile(reservation);
          },
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("보강 내역"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("취소 내역", style: titleLarge),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CanceledMadeUpOriginal(canceledID: canceledID),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          ResultCount(count),
          Expanded(child: child),
        ],
      ),
    );
  }
}
