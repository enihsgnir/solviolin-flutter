import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/clients/branch_client.dart';
import 'package:solviolin_common/providers/dio/dio_provider.dart';

part 'branch_state_provider.g.dart';

@Riverpod(keepAlive: true)
class BranchState extends _$BranchState {
  @override
  BranchClient build() {
    final dio = ref.watch(dioProvider);
    return BranchClient(dio);
  }

  Future<void> register(String branchName) async {
    await state.register(branchName);
  }
}
