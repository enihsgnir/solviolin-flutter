import 'package:solviolin/domains/branch/branch_client.dart';
import 'package:solviolin/utils/client.dart';

final _client = BranchClient(dio);

Future<List<String>> getBranches() async {
  final branches = await _client.getBranches();
  return branches.map((e) => e.branchName).toList();
}
