import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:solviolin_common/models/ledger.dart';
import 'package:solviolin_common/providers/client_state/ledger_state_provider.dart';
import 'package:solviolin_common/providers/ledger_list_provider.dart';
import 'package:solviolin_common/providers/term_provider.dart';
import 'package:solviolin_common/providers/user_detail_ledger_list_provider.dart';
import 'package:solviolin_common/utils/formatters.dart';
import 'package:solviolin_common/utils/theme.dart';
import 'package:solviolin_common/widgets/confirmation_dialog.dart';
import 'package:solviolin_common/widgets/loading_overlay.dart';

class LedgerListTile extends ConsumerWidget {
  final Ledger ledger;
  final bool showActions;

  const LedgerListTile(
    this.ledger, {
    super.key,
    this.showActions = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final term = ref.watch(termProvider(ledger.termID)).valueOrNull;

    final amount = ledger.amount.format(number);
    final paidAt = ledger.paidAt.format(dateTime);

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
              Text("${ledger.branchName} ${ledger.userID}"),
              if (showActions)
                TextButton(
                  onPressed: () => showDelete(context, ref),
                  child: const Text("삭제"),
                ),
            ],
          ),
          const SizedBox(height: 4),
          if (term != null) ...[
            Row(
              children: [
                const Text("학기: "),
                Expanded(
                  child: Text(
                    term.inline,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("금액:"),
              Text("$amount원"),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("결제 시각:"),
              Text(paidAt),
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
        Text("납부 내역을 삭제하시겠습니까?"),
      ],
    );

    if (!isConfirmed) return;

    if (!context.mounted) return;
    await ref
        .read(ledgerStateProvider.notifier)
        .delete(ledger.id)
        .withLoadingOverlay(context);

    // refresh `LedgerListPage`
    ref.invalidate(ledgerListProvider);

    // refresh `UserDetailLedgerList`
    ref.invalidate(userDetailLedgerListProvider);
  }
}
