import 'package:freezed_annotation/freezed_annotation.dart';

const Freezed freezedRequestDto = Freezed(
  copyWith: false,
  equal: false,
  fromJson: false,
  toJson: true,
);

const Freezed freezedResponseDto = Freezed(
  copyWith: false,
  equal: false,
  fromJson: true,
  toJson: false,
);
