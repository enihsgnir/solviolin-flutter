import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/clients/branch_client.dart';
import 'package:solviolin/providers/dio/dio_provider.dart';

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
