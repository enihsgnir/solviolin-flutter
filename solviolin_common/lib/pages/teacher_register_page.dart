import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/form/teacher_register_form_provider.dart';
import 'package:solviolin_common/widgets/branch_select_field.dart';
import 'package:solviolin_common/widgets/confirmation_dialog.dart';
import 'package:solviolin_common/widgets/dow_select_field.dart';
import 'package:solviolin_common/widgets/form_title.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';
import 'package:solviolin_common/widgets/teacher_id_select_field.dart';
import 'package:solviolin_common/widgets/time_select_field.dart';

class TeacherRegisterPage extends ConsumerWidget {
  const TeacherRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      teacherRegisterFormProvider.select((value) => value.enabled),
    );

    final branchName = ref.watch(
      teacherRegisterFormProvider.select((value) => value.teacherBranch),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("강사 스케줄 등록"),
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
        ),
        children: [
          const FormTitle("지점명", isRequired: true),
          BranchSelectField(
            initialValue: branchName,
            onChanged: (value) => ref
                .read(teacherRegisterFormProvider.notifier)
                .setTeacherBranch(value),
          ),
          const FormTitle("강사", isRequired: true),
          TeacherIDSelectField(
            branchName: branchName,
            onChanged: (value) => ref
                .read(teacherRegisterFormProvider.notifier)
                .setTeacherID(value),
          ),
          const FormTitle("요일", isRequired: true),
          DowSelectField(
            initialValue: ref.read(teacherRegisterFormProvider).workDow,
            onChanged: (value) => ref
                .read(teacherRegisterFormProvider.notifier)
                .setWorkDow(value),
          ),
          const FormTitle("시작 시각", isRequired: true),
          TimeSelectField(
            onChanged: (value) => ref
                .read(teacherRegisterFormProvider.notifier)
                .setStartTime(value),
          ),
          const FormTitle("종료 시각", isRequired: true),
          TimeSelectField(
            onChanged: (value) => ref
                .read(teacherRegisterFormProvider.notifier)
                .setEndTime(value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled ? () => showRegister(context, ref) : null,
            child: const Text("등록"),
          ),
        ],
      ),
    );
  }

  Future<void> showRegister(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      content: const [
        Text("강사 스케줄을 등록하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(teacherRegisterFormProvider.notifier)
        .submit()
        .withLoadingOverlay(context);

    if (!context.mounted) return;
    context.pop();
  }
}
