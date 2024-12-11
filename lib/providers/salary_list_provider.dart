import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/salary.dart';
import 'package:solviolin/providers/client_state/reservation_state_provider.dart';
import 'package:solviolin/providers/form/salary_search_form_provider.dart';

part 'salary_list_provider.g.dart';

@riverpod
Future<List<Salary>> salaryList(Ref ref) async {
  final form = ref.watch(salarySearchFormProvider);

  final reservationClient = ref.watch(reservationStateProvider);
  final salaryList = await reservationClient.getSalaries(
    branchName: form.branchName,
    termID: form.termID,
    dayTimeCost: form.dayTimeCost,
    nightTimeCost: form.nightTimeCost,
  );
  return (salaryList as List<dynamic>)
      .map((e) => Salary.fromJson(e as List<dynamic>))
      .toList()
    ..sort((a, b) => a.teacherID.compareTo(b.teacherID));
}
