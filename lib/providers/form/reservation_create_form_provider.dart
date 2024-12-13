import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solviolin/models/dto/reservation_create_request.dart';
import 'package:solviolin/models/form/reservation_create_form_data.dart';
import 'package:solviolin/models/reservation_create_type.dart';
import 'package:solviolin/providers/client_state/reservation_state_provider.dart';

part 'reservation_create_form_provider.g.dart';

@riverpod
class ReservationCreateForm extends _$ReservationCreateForm {
  @override
  ReservationCreateFormData build() {
    return const ReservationCreateFormData(
      type: ReservationCreateType.regular,
      minute: Duration(minutes: 30),
    );
  }

  void setType(ReservationCreateType value) {
    state = state.copyWith(type: value);
  }

  void setMinute(Duration value) {
    state = state.copyWith(minute: value);
  }

  void setUserID(String value) {
    state = state.copyWith(userID: value);
  }

  Future<void> submit({
    required String branchName,
    required String teacherID,
    required DateTime startDate,
  }) async {
    final endDate = startDate.add(state.minute);

    final data = ReservationCreateRequest(
      branchName: branchName,
      teacherID: teacherID,
      userID: state.userID,
      startDate: startDate,
      endDate: endDate,
    );

    switch (state.type) {
      case ReservationCreateType.regular:
        await ref
            .read(reservationStateProvider.notifier)
            .reserveRegular(data: data);

      case ReservationCreateType.makeUp:
        await ref
            .read(reservationStateProvider.notifier)
            .makeUpByAdmin(data: data);

      case ReservationCreateType.free:
        await ref
            .read(reservationStateProvider.notifier)
            .reserveFreeCourse(data: data);
    }
  }
}
