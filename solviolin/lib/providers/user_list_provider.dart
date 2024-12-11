import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/dto/user_search_query.dart';
import 'package:solviolin/models/user.dart';
import 'package:solviolin/models/user_type.dart';
import 'package:solviolin/providers/client_state/user_state_provider.dart';
import 'package:solviolin/providers/form/user_search_form_provider.dart';

part 'user_list_provider.g.dart';

@riverpod
Future<List<User>> userList(Ref ref) async {
  final form = ref.watch(userSearchFormProvider);

  final userType = form.userType;

  final userClient = ref.watch(userStateProvider);
  return await userClient.getAll(
    queries: UserSearchQuery(
      branchName: form.branchName,
      userType: userType,
      userID: form.userID,
      termID: form.termID,
      status: form.status,
      isPaid: userType != UserType.student ? null : form.isPaid,
    ),
  );
}
