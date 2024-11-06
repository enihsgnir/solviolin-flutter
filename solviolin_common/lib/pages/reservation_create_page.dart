import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/models/reservation_create_type.dart';
import 'package:solviolin_common/providers/form/reservation_create_form_provider.dart';
import 'package:solviolin_common/providers/form/reservation_search_form_provider.dart';
import 'package:solviolin_common/providers/reservation_list_provider.dart';
import 'package:solviolin_common/utils/formatters.dart';
import 'package:solviolin_common/utils/theme.dart';
import 'package:solviolin_common/widgets/branch_select_field.dart';
import 'package:solviolin_common/widgets/confirmation_dialog.dart';
import 'package:solviolin_common/widgets/duration_select_field.dart';
import 'package:solviolin_common/widgets/form_title.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';
import 'package:solviolin_common/widgets/reservation_create_type_select_field.dart';
import 'package:solviolin_common/widgets/teacher_id_select_field.dart';

class ReservationCreatePage extends ConsumerWidget {
  final String teacherID;
  final DateTime startDate;

  const ReservationCreatePage({
    super.key,
    required this.teacherID,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchName = ref.watch(
      reservationSearchFormProvider.select((value) => value.branchName),
    );

    final enabled = ref.watch(
      reservationCreateFormProvider.select((value) => value.enabled),
    );

    final type = ref.watch(
      reservationCreateFormProvider.select((value) => value.type),
    );
    final typeDescription = switch (type) {
      ReservationCreateType.regular => "정기 스케줄을 생성하고 수업을 예약합니다",
      ReservationCreateType.makeUp => "관리자의 권한으로 보강을 예약합니다",
      ReservationCreateType.free => "무료 보강 수업을 예약합니다",
    };

    final endDate = ref.watch(
      reservationCreateFormProvider
          .select((value) => startDate.add(value.minute)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("신규 수업 예약"),
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
            readOnly: true,
            onChanged: (value) {},
          ),
          const FormTitle("강사", isRequired: true),
          TeacherIDSelectField(
            branchName: branchName,
            initialValue: teacherID,
            readOnly: true,
            onChanged: (value) {},
          ),
          const FormTitle("수강생 아이디", isRequired: true),
          TextField(
            decoration: const InputDecoration(
              hintText: "수강생 아이디를 입력하세요",
            ),
            onChanged: (value) => ref
                .read(reservationCreateFormProvider.notifier)
                .setUserID(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const FormTitle("수업 종류", isRequired: true),
          ReservationCreateTypeSelectField(
            onChanged: (value) =>
                ref.read(reservationCreateFormProvider.notifier).setType(value),
          ),
          const SizedBox(height: 12),
          Text(typeDescription),
          const FormTitle("수업 시간", isRequired: true),
          DurationSelectField(
            onChanged: (value) => ref
                .read(reservationCreateFormProvider.notifier)
                .setMinute(value),
          ),
          const SizedBox(height: 12),
          Text((startDate, endDate).format(dateTimeRange), style: bodyLarge),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled
                ? () => showReserve(context, ref, branchName: branchName)
                : null,
            child: const Text("예약하기"),
          ),
        ],
      ),
    );
  }

  Future<void> showReserve(
    BuildContext context,
    WidgetRef ref, {
    required String branchName,
  }) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      content: const [
        Text("신규 수업을 예약하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(reservationCreateFormProvider.notifier)
        .submit(
          branchName: branchName,
          teacherID: teacherID,
          startDate: startDate,
        )
        .withLoadingOverlay(context);

    ref.invalidate(reservationListProvider);

    if (!context.mounted) return;
    context.pop();
  }
}
