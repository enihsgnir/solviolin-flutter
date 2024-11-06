import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/salary_list_provider.dart';
import 'package:solviolin_common/widgets/result_count.dart';
import 'package:solviolin_common/widgets/salary_list_tile.dart';
import 'package:solviolin_common/widgets/status_widget.dart';

class SalaryListPage extends ConsumerWidget {
  const SalaryListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salaryList = ref.watch(salaryListProvider);

    final count = salaryList.maybeWhen(
      data: (data) => data.length,
      orElse: () => 0,
    );

    final child = salaryList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyStatusWidget(
            title: "급여 목록이 없습니다",
            subtitle: "검색 조건을 변경해주세요",
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
          itemBuilder: (context, index) => SalaryListTile(data[index]),
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "급여 목록을 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("급여 목록"),
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
