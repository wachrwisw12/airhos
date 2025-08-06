import 'package:flutter/material.dart';

enum SnackBarType { error, success, info }

void showAppSnackBar(
  BuildContext context,
  String message, {
  SnackBarType type = SnackBarType.info,
}) {
  Color backgroundColor;
  switch (type) {
    case SnackBarType.error:
      backgroundColor = Colors.red;
      break;
    case SnackBarType.success:
      backgroundColor = Colors.green;
      break;
    case SnackBarType.info:
    default:
      backgroundColor = Colors.blue;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ),
  );
}
