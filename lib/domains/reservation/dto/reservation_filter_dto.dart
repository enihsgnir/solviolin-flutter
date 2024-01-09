import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/domains/reservation/reservation.dart';

part 'reservation_filter_dto.freezed.dart';
part 'reservation_filter_dto.g.dart';

@freezed
class ReservationFilterDto with _$ReservationFilterDto {
  const factory ReservationFilterDto({
    required String branchName,
    String? teacherID,
    DateTime? startDate,
    DateTime? endDate,
    String? userID,
    required List<BookingStatus> bookingStatus,
  }) = _ReservationFilterDto;

  factory ReservationFilterDto.fromJson(Map<String, dynamic> json) =>
      _$ReservationFilterDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
