

import 'package:flutter/material.dart';
import '../../main.dart';

class GeneralHelper {
  // Create and show snackbar
  static void makeSnackBar(String text) => ScaffoldMessenger.of(globalNavigatorKey.currentContext!).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
    ),
  );

  // Show loading dialog
  static void showLoadingDialog(String message) {
    showDialog(
      context: globalNavigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            Text(message),
          ],
        ),
      ),
    );
  }
}
