import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin_common/models/form/reservation_search_form_data.dart';

part 'reservation_search_form_provider.g.dart';

@riverpod
class ReservationSearchForm extends _$ReservationSearchForm {
  @override
  ReservationSearchFormData build() {
    return const ReservationSearchFormData();
  }

  void search({
    required String branchName,
    String? teacherID,
    String? userID,
  }) {
    state = state.copyWith(
      branchName: branchName,
      teacherID: teacherID,
      userID: userID,
    );
  }
}
