import 'package:solviolin/domains/user/dto/search_user_query_dto.dart';
import 'package:solviolin/domains/user/user.dart';
import 'package:solviolin/domains/user/user_client.dart';
import 'package:solviolin/utils/client.dart';

final _clinet = UserClient(dio);

Future<List<User>> getUsers({
  String? branchName,
  String? userID,
  bool? isPaid,
  UserType? userType,
  UserStatus? status,
  int? termID,
}) async {
  return await _clinet.getUsers(
    SearchUserQueryDto(
      branchName: branchName,
      userID: userID,
      isPaid: isPaid,
      userType: userType,
      status: status,
      termID: termID,
    ),
  );
}

Future<void> terminateTeacher({
  required String teacherID,
}) async {
  await _clinet.terminateTeacher(
    teacherID: teacherID,
    endDate: DateTime.now(),
  );
}
