import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/user.dart';
import 'package:solviolin/providers/user_list_provider.dart';

part 'user_provider.g.dart';

@riverpod
Future<User> user(Ref ref, String userID) async {
  final userList = await ref.watch(userListProvider.future);
  return userList.firstWhere((e) => e.userID == userID);
}
