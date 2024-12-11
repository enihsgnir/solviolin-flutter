import 'package:flutter/material.dart';
import 'package:solviolin/utils/theme.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String message,
  SnackBarAction? action,
}) {
  final snackBar = SnackBar(
    content: Text(message),
    action: action,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showErrorSnackBar(
  BuildContext context, {
  required String message,
}) {
  final snackBar = SnackBar(
    backgroundColor: red,
    content: Text(message, style: const TextStyle(color: white)),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
