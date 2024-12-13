extension DurationCopyWithExtension on Duration {
  Duration copyWith({int? hours, int? minutes}) {
    return Duration(
      hours: hours ?? inHours,
      minutes: minutes ?? inMinutes % Duration.minutesPerHour,
    );
  }
}
