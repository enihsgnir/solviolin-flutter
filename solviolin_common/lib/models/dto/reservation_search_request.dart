import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/models/booking_status.dart';
import 'package:solviolin_common/utils/freezed.dart';

part 'reservation_search_request.freezed.dart';
part 'reservation_search_request.g.dart';

@freezedRequestDto
class ReservationSearchRequest with _$ReservationSearchRequest {
  const factory ReservationSearchRequest({
    required String branchName,
    String? teacherID,
    String? userID,
    DateTime? startDate,
    DateTime? endDate,
    required List<BookingStatus> bookingStatus,
  }) = _ReservationSearchRequest;

  @override
  Map<String, dynamic> toJson();
}
