

import 'package:flutter/material.dart';
import 'package:kahoot_kopi/main.dart';

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

}