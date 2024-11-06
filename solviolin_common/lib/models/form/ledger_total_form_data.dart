import 'package:freezed_annotation/freezed_annotation.dart';

part 'ledger_total_form_data.freezed.dart';

@freezed
class LedgerTotalFormData with _$LedgerTotalFormData {
  const factory LedgerTotalFormData({
    @Default("") String branchName,
    @Default(0) int termID,
  }) = _LedgerTotalFormData;

  const LedgerTotalFormData._();

  bool get enabled => branchName.isNotEmpty && termID != 0;
}
