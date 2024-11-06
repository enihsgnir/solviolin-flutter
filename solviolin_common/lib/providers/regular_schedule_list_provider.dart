import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/regular_schedule.dart';
import 'package:solviolin_common/providers/client_state/regular_schedule_state_provider.dart';

part 'regular_schedule_list_provider.g.dart';

@riverpod
Future<List<RegularSchedule>?> regularScheduleList(
  Ref ref,
  String? userID,
) async {
  final regularScheduleClient = ref.watch(regularScheduleStateProvider);

  try {
    if (userID == null) {
      return await regularScheduleClient.getAllMine();
    }
    return await regularScheduleClient.getAllByUserID(userID);
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      return null;
    }
    rethrow;
  }
}
