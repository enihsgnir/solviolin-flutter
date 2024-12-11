import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/form/salary_search_form_provider.dart';
import 'package:solviolin/widgets/branch_select_field.dart';
import 'package:solviolin/widgets/cost_input_field.dart';
import 'package:solviolin/widgets/form_title.dart';
import 'package:solviolin/widgets/term_select_field.dart';

class SalarySearchPage extends ConsumerWidget {
  const SalarySearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      salarySearchFormProvider.select((value) => value.enabled),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("급여 계산"),
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
                .read(salarySearchFormProvider.notifier)
                .setBranchName(value),
          ),
          const FormTitle("학기", isRequired: true),
          TermSelectField(
            onChanged: (value) =>
                ref.read(salarySearchFormProvider.notifier).setTermID(value),
          ),
          const FormTitle("주간시급", isRequired: true),
          CostInputField(
            hintText: "주간시급을 입력하세요",
            onChanged: (value) => ref
                .read(salarySearchFormProvider.notifier)
                .setDayTimeCost(value),
          ),
          const FormTitle("야간시급", isRequired: true),
          CostInputField(
            hintText: "야간시급을 입력하세요",
            onChanged: (value) => ref
                .read(salarySearchFormProvider.notifier)
                .setNightTimeCost(value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled
                ? () => context.push("/admin/salary/search/result")
                : null,
            child: const Text("검색"),
          ),
        ],
      ),
    );
  }
}
