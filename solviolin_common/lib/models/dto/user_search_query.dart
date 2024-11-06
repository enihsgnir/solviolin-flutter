import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin_common/models/payment_status.dart';
import 'package:solviolin_common/models/user_status.dart';
import 'package:solviolin_common/models/user_type.dart';
import 'package:solviolin_common/utils/freezed.dart';

part 'user_search_query.freezed.dart';
part 'user_search_query.g.dart';

@freezedRequestDto
class UserSearchQuery with _$UserSearchQuery {
  const factory UserSearchQuery({
    String? branchName,
    UserType? userType,
    UserStatus? status,
    int? termID,
    PaymentStatus? isPaid,
    String? userID,
  }) = _UserSearchQuery;

  @override
  Map<String, dynamic> toJson();
}
