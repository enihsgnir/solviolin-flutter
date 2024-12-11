import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/utils/freezed.dart';

part 'reservation_create_request.freezed.dart';
part 'reservation_create_request.g.dart';

@freezedRequestDto
class ReservationCreateRequest with _$ReservationCreateRequest {
  const factory ReservationCreateRequest({
    required String branchName,
    required String teacherID,
    required String userID,
    required DateTime startDate,
    required DateTime endDate,
  }) = _ReservationCreateRequest;

  @override
  Map<String, dynamic> toJson();
}
