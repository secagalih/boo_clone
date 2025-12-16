import 'package:flutter/material.dart';

/// Custom action button widget for like and pass actions
class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final double size;

  const ActionButton({super.key, required this.icon, required this.color, required this.onPressed, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: CircleBorder(),
          child: Center(
            child: Icon(icon, color: color, size: size * 0.5),
          ),
        ),
      ),
    );
  }
}
