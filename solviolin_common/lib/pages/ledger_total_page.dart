import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/form/ledger_total_form_provider.dart';
import 'package:solviolin_common/utils/formatters.dart';
import 'package:solviolin_common/widgets/branch_select_field.dart';
import 'package:solviolin_common/widgets/form_title.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';
import 'package:solviolin_common/widgets/term_select_field.dart';

class LedgerTotalPage extends HookConsumerWidget {
  const LedgerTotalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(
      ledgerTotalFormProvider.select((value) => value.enabled),
    );

    final total = useState<int?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text("매출 총액 조회"),
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
            onChanged: (value) =>
                ref.read(ledgerTotalFormProvider.notifier).setBranchName(value),
          ),
          const FormTitle("학기", isRequired: true),
          TermSelectField(
            onChanged: (value) =>
                ref.read(ledgerTotalFormProvider.notifier).setTermID(value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled
                ? () async {
                    total.value = await ref
                        .read(ledgerTotalFormProvider.notifier)
                        .search()
                        .withLoadingOverlay(context);
                  }
                : null,
            child: const Text("조회"),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("총액:"),
              Text("${total.value.format(number)}원"),
            ],
          ),
        ],
      ),
    );
  }
}
