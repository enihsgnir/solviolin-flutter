import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/canceled_list_provider.dart';
import 'package:solviolin_common/widgets/canceled_list_tile.dart';
import 'package:solviolin_common/widgets/result_count.dart';
import 'package:solviolin_common/widgets/status_widget.dart';

class CanceledListPage extends ConsumerWidget {
  const CanceledListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canceledList = ref.watch(canceledListProvider);

    final count = canceledList.maybeWhen(
      data: (data) => data.length,
      orElse: () => 0,
    );

    final child = canceledList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyStatusWidget(
            title: "취소 내역이 없습니다",
            subtitle: "검색 조건을 변경해보세요",
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
          itemBuilder: (context, index) => CanceledListTile(data[index]),
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "취소 내역을 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("취소 내역"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResultCount(count),
          Expanded(child: child),
        ],
      ),
    );
  }
}
