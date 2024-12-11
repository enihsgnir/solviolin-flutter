import 'dart:developer';

import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    errorMethodCount: null,
    printEmojis: false,
    dateTimeFormat: DateTimeFormat.onlyTime,
  ),
  output: DeveloperConsoleOutput(),
);

class DeveloperConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final buffer = StringBuffer();
    event.lines.forEach(buffer.writeln);
    log(buffer.toString(), name: event.level.label);
  }
}

extension on Level {
  static final _labels = {
    Level.trace: "TRACE",
    Level.debug: "DEBUG",
    Level.info: "INFO",
    Level.warning: "WARN",
    Level.error: "ERROR",
    Level.fatal: "FATAL",
  };

  String get label => (_labels[this] ?? "").padLeft(5);
}
