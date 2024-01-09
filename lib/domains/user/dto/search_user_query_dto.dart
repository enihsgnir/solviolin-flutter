import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/domains/user/user.dart';

part 'search_user_query_dto.freezed.dart';
part 'search_user_query_dto.g.dart';

@freezed
class SearchUserQueryDto with _$SearchUserQueryDto {
  const factory SearchUserQueryDto({
    String? branchName,
    String? userID,
    @BooleanToIntConverter() bool? isPaid,
    UserType? userType,
    UserStatus? status,
    int? termID,
  }) = _SearchUserQueryDto;

  factory SearchUserQueryDto.fromJson(Map<String, dynamic> json) =>
      _$SearchUserQueryDtoFromJson(json);
}

class BooleanToIntConverter implements JsonConverter<bool, int> {
  const BooleanToIntConverter();

  @override
  bool fromJson(int json) {
    return json != 0;
  }

  @override
  int toJson(bool object) {
    return object ? 1 : 0;
  }
}
