import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/utils/freezed.dart';

part 'check_in_search_request.freezed.dart';
part 'check_in_search_request.g.dart';

@freezedRequestDto
class CheckInSearchRequest with _$CheckInSearchRequest {
  const factory CheckInSearchRequest({
    required String branchName,
    DateTime? startDate,
    DateTime? endDate,
  }) = _CheckInSearchRequest;

  @override
  Map<String, dynamic> toJson();
}
