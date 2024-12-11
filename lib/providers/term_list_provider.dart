import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/term.dart';
import 'package:solviolin/providers/client_state/term_state_provider.dart';

part 'term_list_provider.g.dart';

@Riverpod(keepAlive: true)
Future<List<Term>> termList(Ref ref) async {
  final termClient = ref.watch(termStateProvider);
  return await termClient.getAll(0);
}
