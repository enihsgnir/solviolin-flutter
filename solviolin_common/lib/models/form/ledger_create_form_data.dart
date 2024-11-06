import 'package:freezed_annotation/freezed_annotation.dart';

part 'ledger_create_form_data.freezed.dart';

@freezed
class LedgerCreateFormData with _$LedgerCreateFormData {
  const factory LedgerCreateFormData({
    @Default("") String branchName,
    @Default("") String userID,
    @Default(0) int termID,
    @Default(0) int amount,
  }) = _LedgerCreateFormData;

  const LedgerCreateFormData._();

  bool get enabled =>
      branchName.isNotEmpty && userID.isNotEmpty && termID != 0 && amount >= 0;
}
