import 'package:flutter/material.dart';

class CustomImageBtn extends StatefulWidget {
  final String text;
  final void Function() onTap;
  final Widget imageWidget;

  const CustomImageBtn({super.key, required this.text, required this.onTap, required this.imageWidget});

  @override
  State<CustomImageBtn> createState() => _CustomImageBtnState();
}

class _CustomImageBtnState extends State<CustomImageBtn> {
  bool _isPressed = false;

  @override
  // Custom button with image and text
  Widget build(BuildContext context) => GestureDetector(
    // Run given function when pressed
    onTap: () async => {widget.onTap()},
    child: Container(
      padding: const EdgeInsets.all(10),
      height: 60,
      width: 300,
      decoration: BoxDecoration(
        color: _isPressed ? Colors.deepPurple.withValues(alpha: 0.6) :Colors.deepPurple,
        border: Border.all(),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          //Image
          SizedBox(height: 45, child: widget.imageWidget),
          //Text
          const Spacer(),
          Center(child: Text(widget.text, style: TextStyle(color: Colors.white, fontSize: 22))),
          const Spacer(),
        ],
      ),
    ),
  );
}