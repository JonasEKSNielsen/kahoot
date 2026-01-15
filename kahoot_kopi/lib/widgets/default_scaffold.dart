import 'package:flutter/material.dart';
import 'package:kahoot_kopi/widgets/default_appbar.dart';

class DefaultScaffold extends StatelessWidget  {
  const DefaultScaffold({super.key, this.title, required this.child});
  final String? title;
  final Widget child;

  @override
  // Custom button with image and text
  Widget build(BuildContext context) => Scaffold(
      appBar: DefaultAppbar(title: title),
      body: child,
  );
}