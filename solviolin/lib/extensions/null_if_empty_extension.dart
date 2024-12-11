extension NullIfEmptyExtension on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
