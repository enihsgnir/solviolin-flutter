import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/utils/freezed.dart';

part 'term_create_request.freezed.dart';
part 'term_create_request.g.dart';

@freezedRequestDto
class TermCreateRequest with _$TermCreateRequest {
  const factory TermCreateRequest({
    required DateTime termStart,
    required DateTime termEnd,
  }) = _TermCreateRequest;

  @override
  Map<String, dynamic> toJson();
}
