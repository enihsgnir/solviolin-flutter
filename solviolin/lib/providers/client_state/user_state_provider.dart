import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/clients/user_client.dart';
import 'package:solviolin/models/dto/teacher_terminate_request.dart';
import 'package:solviolin/models/dto/user_register_request.dart';
import 'package:solviolin/models/dto/user_update_request.dart';
import 'package:solviolin/models/user_status.dart';
import 'package:solviolin/models/user_type.dart';
import 'package:solviolin/providers/dio/dio_provider.dart';

part 'user_state_provider.g.dart';

@Riverpod(keepAlive: true)
class UserState extends _$UserState {
  @override
  UserClient build() {
    final dio = ref.watch(dioProvider);
    return UserClient(dio);
  }

  Future<void> register({
    required String userID,
    required String userPassword,
    required String userName,
    required String userPhone,
    required UserType userType,
    required String userBranch,
  }) async {
    final data = UserRegisterRequest(
      userID: userID,
      userPassword: userPassword,
      userName: userName,
      userPhone: userPhone,
      userType: userType,
      userBranch: userBranch,
    );
    await state.register(data: data);
  }

  Future<void> update(
    String userID, {
    String? userName,
    String? userPhone,
    String? userBranch,
    int? userCredit,
    UserStatus? status,
    Color? color,
  }) async {
    final data = UserUpdateRequest(
      userName: userName,
      userPhone: userPhone,
      userCredit: userCredit,
      userBranch: userBranch,
      status: status,
      color: color,
    );
    await state.update(userID, data: data);
  }

  Future<void> resetPassword({
    required String userID,
    required String userPassword,
  }) async {
    await state.resetPassword(userID: userID, userPassword: userPassword);
  }

  Future<void> initializeCredit() async {
    await state.initializeCredit();
  }

  Future<void> terminateTeacher(String teacherID) async {
    final data = TeacherTerminateRequest(
      teacherID: teacherID,
      endDate: DateTime.now(),
    );
    await state.terminateTeacher(data: data);
  }
}
