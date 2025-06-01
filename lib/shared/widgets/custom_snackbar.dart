import 'package:flutter/material.dart';
import 'package:vira/shared/theme/app_colors.dart';

void showCustomSnackbar(BuildContext context, String message,
    {bool isError = false}) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: isError ? AppColors.error : AppColors.success,
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
