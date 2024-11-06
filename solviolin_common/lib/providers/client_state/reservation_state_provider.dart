import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/clients/reservation_client.dart';
import 'package:solviolin_common/models/dto/reservation_create_request.dart';
import 'package:solviolin_common/models/dto/reservation_update_request.dart';
import 'package:solviolin_common/models/dto/term_create_request.dart';
import 'package:solviolin_common/providers/dio/dio_provider.dart';

part 'reservation_state_provider.g.dart';

@Riverpod(keepAlive: true)
class ReservationState extends _$ReservationState {
  @override
  ReservationClient build() {
    final dio = ref.watch(dioProvider);
    return ReservationClient(dio);
  }

  Future<void> cancel(int id) async {
    await state.cancel(id);
  }

  Future<void> cancelByAdmin(
    int id, {
    required bool deductCredit,
  }) async {
    final count = deductCredit ? 1 : 0;
    await state.cancelByAdmin(id, count: count);
  }

  Future<void> makeUp({
    required String teacherID,
    required String branchName,
    required DateTime startDate,
    required DateTime endDate,
    required String userID,
  }) async {
    final data = ReservationCreateRequest(
      branchName: branchName,
      teacherID: teacherID,
      userID: userID,
      startDate: startDate,
      endDate: endDate,
    );
    await state.makeUp(data: data);
  }

  Future<void> makeUpByAdmin({
    required ReservationCreateRequest data,
  }) async {
    await state.makeUpByAdmin(data: data);
  }

  Future<void> extend(int id) async {
    await state.extend(id);
  }

  Future<void> extendByAdmin(
    int id, {
    required bool deductCredit,
  }) async {
    final count = deductCredit ? 1 : 0;
    await state.extendByAdmin(id, count: count);
  }

  Future<void> reserveRegular({
    required ReservationCreateRequest data,
  }) async {
    await state.reserveRegular(data: data);
  }

  Future<void> reserveFreeCourse({
    required ReservationCreateRequest data,
  }) async {
    await state.reserveFreeCourse(data: data);
  }

  Future<void> updateEndDateAndDeleteLaterCourse(
    int id, {
    required DateTime endDate,
  }) async {
    final data = ReservationUpdateRequest(endDate: endDate);
    await state.updateEndDateAndDeleteLaterCourse(id, data: data);
  }

  Future<void> extendAllCoursesOfBranch(String branch) async {
    await state.extendAllCoursesOfBranch(branch);
  }

  Future<void> extendAllCoursesOfUser(String userID) async {
    await state.extendAllCoursesOfUser(userID);
  }

  Future<void> delete(int id) async {
    await state.delete(ids: [id]);
  }

  Future<void> modifyTerm(
    int id, {
    required DateTime termStart,
    required DateTime termEnd,
  }) async {
    final data = TermCreateRequest(
      termStart: termStart,
      termEnd: termEnd,
    );
    await state.modifyTerm(id, data: data);
  }
}
