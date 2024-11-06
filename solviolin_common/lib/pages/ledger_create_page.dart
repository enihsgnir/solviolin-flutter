import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/providers/form/ledger_create_form_provider.dart';
import 'package:solviolin_common/providers/term_range_provider.dart';
import 'package:solviolin_common/providers/user_detail_ledger_list_provider.dart';
import 'package:solviolin_common/widgets/branch_select_field.dart';
import 'package:solviolin_common/widgets/confirmation_dialog.dart';
import 'package:solviolin_common/widgets/cost_input_field.dart';
import 'package:solviolin_common/widgets/form_title.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';
import 'package:solviolin_common/widgets/term_select_field.dart';

class LedgerCreatePage extends StatefulHookConsumerWidget {
  final String? branchName;
  final String? userID;

  const LedgerCreatePage({
    super.key,
    this.branchName,
    this.userID,
  });

  @override
  ConsumerState<LedgerCreatePage> createState() => _LedgerCreatePageState();
}

class _LedgerCreatePageState extends ConsumerState<LedgerCreatePage> {
  @override
  void initState() {
    super.initState();

    final userID = widget.userID;
    if (userID != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ref.read(ledgerCreateFormProvider.notifier).setUserID(userID);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(
      ledgerCreateFormProvider.select((value) => value.enabled),
    );

    final currentTerm = ref.watch(termRangeProvider).valueOrNull?.current;

    final controller = useTextEditingController(text: widget.userID);

    return Scaffold(
      appBar: AppBar(
        title: const Text("원비 납부"),
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
            initialValue: widget.branchName,
            onChanged: (value) => ref
                .read(ledgerCreateFormProvider.notifier)
                .setBranchName(value),
          ),
          const FormTitle("학기", isRequired: true),
          TermSelectField(
            initialValue: currentTerm,
            onChanged: (value) =>
                ref.read(ledgerCreateFormProvider.notifier).setTermID(value),
          ),
          const FormTitle("수강생 아이디", isRequired: true),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "수강생 아이디를 입력하세요",
            ),
            onChanged: (value) =>
                ref.read(ledgerCreateFormProvider.notifier).setUserID(value),
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
          const FormTitle("납부 금액", isRequired: true),
          CostInputField(
            hintText: "납부 금액을 입력하세요",
            onChanged: (value) =>
                ref.read(ledgerCreateFormProvider.notifier).setAmount(value),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: enabled ? () => showExpend(context, ref) : null,
            child: const Text("납부"),
          ),
        ],
      ),
    );
  }

  Future<void> showExpend(BuildContext context, WidgetRef ref) async {
    final isConfirmed = await showConfirmationDialog(
      context,
      content: const [
        Text("원비를 납부하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(ledgerCreateFormProvider.notifier)
        .submit()
        .withLoadingOverlay(context);

    // in case of page pushed from `UserDetailPage`
    ref.invalidate(userDetailLedgerListProvider);

    if (!context.mounted) return;
    context.pop();
  }
}
