import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/term_range.dart';
import 'package:solviolin_common/providers/term_list_provider.dart';

part 'term_range_provider.g.dart';

/// [TermRange] manages the current, previous, and next terms.
/// Terms must be manually added by an administrator, and proper registration
/// is critical to ensure the accuracy of [TermRange].
/// If terms are not correctly managed, terms within [TermRange] may overlap
/// or be identical, leading to configuration issues.
@Riverpod(keepAlive: true)
Future<TermRange> termRange(Ref ref) async {
  final termList = await ref.watch(termListProvider.future);

  final today = DateTime.now();
  final i = termList.indexWhere((e) => e.termEnd.isBefore(today));

  return TermRange(
    previous: termList[max(0, i)],
    current: termList[max(0, i - 1)],
    next: termList[max(0, i - 2)],
  );
}
