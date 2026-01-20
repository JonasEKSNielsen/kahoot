import 'package:flutter/material.dart';
import 'ui/pin_page/pin_page.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalNavigatorKey,
      title: 'Flutter Kahoot Kopi',
      home: const PinPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

