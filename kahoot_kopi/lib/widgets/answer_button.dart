
import 'package:flutter/material.dart';

class AnswerButton extends StatefulWidget {
  final dynamic answer;
  final Color color;
  final VoidCallback onPressed;

  const AnswerButton({super.key, required this.answer, required this.color, required this.onPressed});

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        widget.onPressed();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: Container(
        color: _isPressed ? widget.color.withValues(alpha: 0.6) : widget.color,
        child: Center(
          child: Text(
            '${widget.answer.text}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}