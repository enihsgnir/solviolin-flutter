import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/ledger.dart';
import 'package:solviolin/providers/client_state/ledger_state_provider.dart';

part 'user_detail_ledger_list_provider.g.dart';

@riverpod
Future<List<Ledger>> userDetailLedgerList(Ref ref, String userID) async {
  final ledgerClient = ref.watch(ledgerStateProvider);
  final ledgerList = await ledgerClient.getAll(userID: userID);
  return ledgerList..sort((a, b) => b.paidAt.compareTo(a.paidAt));
}
