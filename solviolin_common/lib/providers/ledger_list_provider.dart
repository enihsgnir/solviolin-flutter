import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/ledger.dart';
import 'package:solviolin_common/providers/client_state/ledger_state_provider.dart';
import 'package:solviolin_common/providers/form/ledger_search_form_provider.dart';

part 'ledger_list_provider.g.dart';

@riverpod
Future<List<Ledger>> ledgerList(Ref ref) async {
  final form = ref.watch(ledgerSearchFormProvider);

  final ledgerClient = ref.watch(ledgerStateProvider);
  final ledgerList = await ledgerClient.getAll(
    branchName: form.branchName,
    termID: form.termID,
    userID: form.userID,
  );
  return ledgerList..sort((a, b) => b.paidAt.compareTo(a.paidAt));
}
