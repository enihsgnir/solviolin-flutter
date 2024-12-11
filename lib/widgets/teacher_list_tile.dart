import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/models/teacher.dart';
import 'package:solviolin/providers/client_state/teacher_state_provider.dart';
import 'package:solviolin/providers/teacher_list_provider.dart';
import 'package:solviolin/utils/formatters.dart';
import 'package:solviolin/utils/theme.dart';
import 'package:solviolin/widgets/confirmation_dialog.dart';
import 'package:solviolin/widgets/loading_overlay.dart';

class TeacherListTile extends ConsumerWidget {
  final Teacher teacher;
  final bool showActions;

  const TeacherListTile(
    this.teacher, {
    super.key,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final start = teacher.startTime.format(durationTime);
    final end = teacher.endTime.format(durationTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(color: gray100),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${teacher.branchName} ${teacher.teacherID}"),
              if (showActions)
                TextButton(
                  onPressed: () => showDelete(context, ref),
                  child: const Text("삭제"),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("요일:"),
              Text(teacher.workDow.inline),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("시간:"),
              Text("$start ~ $end"),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> showDelete(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      isDestructive: true,
      content: const [
        Text("정말로 삭제 하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(teacherStateProvider.notifier)
        .delete(teacher.id)
        .withLoadingOverlay(context);

    ref.invalidate(teacherListProvider);
  }
}
