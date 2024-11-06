import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/term.dart';
import 'package:solviolin_common/providers/term_list_provider.dart';

part 'term_provider.g.dart';

@riverpod
Future<Term> term(Ref ref, int id) async {
  final termList = await ref.watch(termListProvider.future);
  return termList.singleWhere((e) => e.id == id);
}
