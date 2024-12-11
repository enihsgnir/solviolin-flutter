import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/models/reservation_create_type.dart';

part 'reservation_create_form_data.freezed.dart';

@freezed
class ReservationCreateFormData with _$ReservationCreateFormData {
  const factory ReservationCreateFormData({
    required ReservationCreateType type,
    required Duration minute,
    @Default("") String userID,
  }) = _ReservationCreateFormData;

  const ReservationCreateFormData._();

  bool get enabled => userID.isNotEmpty;
}
