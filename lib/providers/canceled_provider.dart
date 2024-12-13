import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/canceled.dart';
import 'package:solviolin/providers/canceled_list_provider.dart';

part 'canceled_provider.g.dart';

@riverpod
Future<Canceled> canceled(Ref ref, int id) async {
  final canceledList = await ref.watch(canceledListProvider.future);
  return canceledList.firstWhere((e) => e.id == id);
}
