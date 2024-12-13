import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/utils/freezed.dart';

part 'available_spot_search_request.freezed.dart';
part 'available_spot_search_request.g.dart';

@freezedRequestDto
class AvailableSpotSearchRequest with _$AvailableSpotSearchRequest {
  const factory AvailableSpotSearchRequest({
    required String branchName,
    required String teacherID,
    required DateTime startDate,
  }) = _AvailableSpotSearchRequest;

  @override
  Map<String, dynamic> toJson();
}
