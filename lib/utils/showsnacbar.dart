import 'package:flutter/material.dart';
import 'package:vista_practica/utils/app_colors.dart';


void showSnackbar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: AppColors.oscureColor,
      content: Text(
        content,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 16.0,
        ),
      ),
    ),
  );
}