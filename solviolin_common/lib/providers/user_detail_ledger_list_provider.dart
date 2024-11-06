import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/ledger.dart';
import 'package:solviolin_common/providers/client_state/ledger_state_provider.dart';

part 'user_detail_ledger_list_provider.g.dart';

@riverpod
Future<List<Ledger>> userDetailLedgerList(Ref ref, String userID) async {
  final ledgerClient = ref.watch(ledgerStateProvider);
  final ledgerList = await ledgerClient.getAll(userID: userID);
  return ledgerList..sort((a, b) => b.paidAt.compareTo(a.paidAt));
}
