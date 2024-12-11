import 'package:excel/excel.dart';

List<int> saveExcel(List<List<String>> data) {
  final excel = Excel.createExcel();

  final sheet = excel["Sheet1"];
  for (final row in data) {
    sheet.appendRow([
      for (final text in row) TextCellValue(text),
    ]);
  }

  final fileBytes = excel.save();
  if (fileBytes == null) {
    throw Exception("failed to save excel file");
  }

  return fileBytes;
}
