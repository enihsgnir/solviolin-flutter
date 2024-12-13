import 'package:freezed_annotation/freezed_annotation.dart';

part 'ledger_search_form_data.freezed.dart';

@freezed
class LedgerSearchFormData with _$LedgerSearchFormData {
  const factory LedgerSearchFormData({
    @Default("") String branchName,
    @Default(0) int termID,
    String? userID,
  }) = _LedgerSearchFormData;

  const LedgerSearchFormData._();

  bool get enabled => branchName.isNotEmpty && termID != 0;
}
