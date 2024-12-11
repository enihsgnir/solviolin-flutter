import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/utils/freezed.dart';

part 'reservation_update_request.freezed.dart';
part 'reservation_update_request.g.dart';

@freezedRequestDto
class ReservationUpdateRequest with _$ReservationUpdateRequest {
  const factory ReservationUpdateRequest({
    required DateTime endDate,
  }) = _ReservationUpdateRequest;

  @override
  Map<String, dynamic> toJson();
}
