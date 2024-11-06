import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/models/cancel_in_close.dart';
import 'package:solviolin_common/models/control_status.dart';
import 'package:solviolin_common/providers/form/control_register_form_provider.dart';
import 'package:solviolin_common/utils/theme.dart';
import 'package:solviolin_common/widgets/branch_select_field.dart';
import 'package:solviolin_common/widgets/cancel_in_close_select_field.dart';
import 'package:solviolin_common/widgets/confirmation_dialog.dart';
import 'package:solviolin_common/widgets/control_status_select_field.dart';
import 'package:solviolin_common/widgets/date_select_field.dart';
import 'package:solviolin_common/widgets/form_title.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';
import 'package:solviolin_common/widgets/teacher_id_select_field.dart';
import 'package:solviolin_common/widgets/time_select_field.dart';

class ControlRegisterPage extends ConsumerWidget {
  const ControlRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      controlRegisterFormProvider.select((value) => value.enabled),
    );

    final branchName = ref.watch(
      controlRegisterFormProvider.select((value) => value.branchName),
    );

    final controlStatus = ref.watch(
      controlRegisterFormProvider.select((value) => value.status),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("오픈/클로즈 등록"),
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
                .read(controlRegisterFormProvider.notifier)
                .setBranchName(value),
          ),
          const FormTitle("강사", isRequired: true),
          TeacherIDSelectField(
            branchName: branchName,
            onChanged: (value) => ref
                .read(controlRegisterFormProvider.notifier)
                .setTeacherID(value),
          ),
          const FormTitle("시작일", isRequired: true),
          DateSelectField(
            onChanged: (value) => ref
                .read(controlRegisterFormProvider.notifier)
                .setControlStartDate(value),
          ),
          const SizedBox(height: 8),
          TimeSelectField(
            onChanged: (value) => ref
                .read(controlRegisterFormProvider.notifier)
                .setControlStartTime(value),
          ),
          const FormTitle("종료일", isRequired: true),
          DateSelectField(
            onChanged: (value) => ref
                .read(controlRegisterFormProvider.notifier)
                .setControlEndDate(value),
          ),
          const SizedBox(height: 8),
          TimeSelectField(
            onChanged: (value) => ref
                .read(controlRegisterFormProvider.notifier)
                .setControlEndTime(value),
          ),
          const FormTitle("오픈/클로즈", isRequired: true),
          ControlStatusSelectField(
            onChanged: (value) =>
                ref.read(controlRegisterFormProvider.notifier).setStatus(value),
          ),
          const FormTitle("클로즈 기간 내 수업 상태"),
          CancelInCloseSelectField(
            enabled: controlStatus == ControlStatus.close,
            onChanged: (value) => ref
                .read(controlRegisterFormProvider.notifier)
                .setCancelInClose(value),
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
        Text("오픈/클로즈를 등록하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    final form = ref.read(controlRegisterFormProvider);
    final shouldConfirmAgain = form.status == ControlStatus.close &&
        form.cancelInClose == CancelInClose.delete;
    if (shouldConfirmAgain) {
      if (!context.mounted) return;
      final isConfirmedAgain = await showConfirmationDialog(
        context,
        isDestructive: true,
        content: [
          const Text("클로즈 기간 내 예약을 삭제하시겠습니까?"),
          const SizedBox(height: 8),
          const Text("취소 내역에 기록되지 않습니다"),
          const SizedBox(height: 8),
          const Text(
            "되돌릴 수 없습니다",
            style: TextStyle(
              color: red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "취소와는 다른 기능입니다",
            style: TextStyle(
              color: red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "강제로 예약 데이터를 삭제합니다",
            style: TextStyle(
              color: red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "예상치 못한 오류가 발생할 수 있습니다",
            style: TextStyle(
              color: red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "되도록 권장하지 않습니다",
            style: TextStyle(
              color: red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

      if (!isConfirmedAgain) return;
    }

    if (!context.mounted) return;
    await ref
        .read(controlRegisterFormProvider.notifier)
        .submit()
        .withLoadingOverlay(context);

    if (!context.mounted) return;
    context.pop();
  }
}
