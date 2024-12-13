import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/check_in_list_provider.dart';
import 'package:solviolin/widgets/check_in_list_tile.dart';
import 'package:solviolin/widgets/result_count.dart';
import 'package:solviolin/widgets/status_widget.dart';

class CheckInListPage extends ConsumerWidget {
  const CheckInListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkInList = ref.watch(checkInListProvider);

    final count = checkInList.maybeWhen(
      data: (data) => data.length,
      orElse: () => 0,
    );

    final child = checkInList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyStatusWidget(
            title: "체크인 이력이 없습니다",
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
          itemBuilder: (context, index) => CheckInListTile(data[index]),
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "체크인 이력을 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("체크인 이력"),
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
