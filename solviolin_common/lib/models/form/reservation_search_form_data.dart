import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation_search_form_data.freezed.dart';

@freezed
class ReservationSearchFormData with _$ReservationSearchFormData {
  const factory ReservationSearchFormData({
    @Default("") String branchName,
    String? teacherID,
    String? userID,
  }) = _ReservationSearchFormData;

  const ReservationSearchFormData._();

  bool get enabled => branchName.isNotEmpty;
}
