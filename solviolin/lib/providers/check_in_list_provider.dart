import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/check_in.dart';
import 'package:solviolin/models/dto/check_in_search_request.dart';
import 'package:solviolin/providers/client_state/check_in_state_provider.dart';
import 'package:solviolin/providers/form/check_in_search_form_provider.dart';

part 'check_in_list_provider.g.dart';

@riverpod
Future<List<CheckIn>> checkInList(Ref ref) async {
  const timezoneOffset = Duration(hours: 9);
  const endDateOffset = Duration(days: 1);

  final form = ref.watch(checkInSearchFormProvider);
  final data = CheckInSearchRequest(
    branchName: form.branchName,
    startDate: form.startDate.subtract(timezoneOffset),
    endDate: form.endDate.subtract(timezoneOffset).add(endDateOffset),
  );

  final checkInClient = ref.watch(checkInStateProvider);
  final checkInList = await checkInClient.search(data: data);
  return checkInList..sort((a, b) => b.createdAt.compareTo(a.createdAt));
}
