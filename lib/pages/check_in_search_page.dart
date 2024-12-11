import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/form/check_in_search_form_provider.dart';
import 'package:solviolin/widgets/branch_select_field.dart';
import 'package:solviolin/widgets/date_select_field.dart';
import 'package:solviolin/widgets/form_title.dart';

class CheckInSearchPage extends ConsumerWidget {
  const CheckInSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      checkInSearchFormProvider.select((value) => value.enabled),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("체크인 이력 검색"),
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
            onChanged: (value) => ref
                .read(checkInSearchFormProvider.notifier)
                .setBranchName(value),
          ),
          const FormTitle("시작일", isRequired: true),
          DateSelectField(
            initialValue: ref.read(checkInSearchFormProvider).startDate,
            onChanged: (value) => ref
                .read(checkInSearchFormProvider.notifier)
                .setStartDate(value),
          ),
          const FormTitle("종료일", isRequired: true),
          DateSelectField(
            initialValue: ref.read(checkInSearchFormProvider).endDate,
            onChanged: (value) =>
                ref.read(checkInSearchFormProvider.notifier).setEndDate(value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled
                ? () => context.push("/admin/check-in/search/result")
                : null,
            child: const Text("검색"),
          ),
        ],
      ),
    );
  }
}
