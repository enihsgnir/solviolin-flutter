import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/teacher_list_provider.dart';
import 'package:solviolin_common/widgets/edit_mode_toggle_button.dart';
import 'package:solviolin_common/widgets/result_count.dart';
import 'package:solviolin_common/widgets/status_widget.dart';
import 'package:solviolin_common/widgets/teacher_list_tile.dart';

class TeacherListPage extends HookConsumerWidget {
  const TeacherListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teacherList = ref.watch(teacherListProvider);

    final count = teacherList.maybeWhen(
      data: (data) => data.length,
      orElse: () => 0,
    );

    final showActions = useState(false);

    final child = teacherList.when(
      data: (data) {
        if (data.isEmpty) {
          return const EmptyStatusWidget(
            title: "강사 스케줄이 없습니다",
            subtitle: "강사 스케줄을 등록해주세요",
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
          itemBuilder: (context, index) =>
              TeacherListTile(data[index], showActions: showActions.value),
        );
      },
      error: (error, stackTrace) {
        return const EmptyStatusWidget(
          title: "강사 스케줄을 조회할 수 없습니다",
          subtitle: "잠시 후 다시 시도해주세요",
        );
      },
      loading: () => const LoadingStatusWidget(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("강사 스케줄"),
        actions: [
          EditModeToggleButton(
            enabled: showActions.value,
            onChanged: (value) => showActions.value = value,
          ),
        ],
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
