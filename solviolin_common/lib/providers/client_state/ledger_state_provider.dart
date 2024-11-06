import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/clients/ledger_client.dart';
import 'package:solviolin_common/providers/dio/dio_provider.dart';

part 'ledger_state_provider.g.dart';

@Riverpod(keepAlive: true)
class LedgerState extends _$LedgerState {
  @override
  LedgerClient build() {
    final dio = ref.watch(dioProvider);
    return LedgerClient(dio);
  }

  Future<void> register({
    required String branchName,
    required int termID,
    required String userID,
    required int amount,
  }) async {
    await state.create(
      branchName: branchName,
      termID: termID,
      userID: userID,
      amount: amount,
    );
  }

  Future<void> delete(int id) async {
    await state.delete(id);
  }
}
