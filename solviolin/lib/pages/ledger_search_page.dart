import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin/providers/form/ledger_search_form_provider.dart';
import 'package:solviolin/widgets/branch_select_field.dart';
import 'package:solviolin/widgets/form_title.dart';
import 'package:solviolin/widgets/term_select_field.dart';

class LedgerSearchPage extends ConsumerWidget {
  const LedgerSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      ledgerSearchFormProvider.select((value) => value.enabled),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("매출 검색"),
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
                .read(ledgerSearchFormProvider.notifier)
                .setBranchName(value),
          ),
          const FormTitle("학기", isRequired: true),
          TermSelectField(
            onChanged: (value) =>
                ref.read(ledgerSearchFormProvider.notifier).setTermID(value),
          ),
          const FormTitle("수강생 아이디"),
          TextField(
            decoration: const InputDecoration(
              hintText: "수강생 아이디를 입력하세요",
            ),
            onChanged: (value) =>
                ref.read(ledgerSearchFormProvider.notifier).setUserID(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled
                ? () => context.push("/admin/ledger/search/result")
                : null,
            child: const Text("검색"),
          ),
        ],
      ),
    );
  }
}
