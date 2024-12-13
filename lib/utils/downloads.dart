import 'dart:io';

import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

String getTimeStamp() {
  final now = DateTime.now();
  return DateFormat("yyMMdd_HHmmss").format(now);
}

Future<void> saveDownloads({
  required String basename,
  required String extension,
  required List<int> bytes,
}) async {
  final tempDir = await getTemporaryDirectory();

  final file = File("${tempDir.path}/$basename.$extension");
  await file.writeAsBytes(bytes);

  await copyFileIntoDownloadFolder(
    file.path,
    basename,
    desiredExtension: extension,
  );

  await file.delete();
}

Future<void> openDownloads() async {
  await openDownloadFolder();
}
