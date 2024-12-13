import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:solviolin/models/payment_status.dart';
import 'package:solviolin/models/user_status.dart';
import 'package:solviolin/models/user_type.dart';
import 'package:solviolin/utils/freezed.dart';

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
