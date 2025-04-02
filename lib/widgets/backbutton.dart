//create a custom back button to force a refresh
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final Color color; // Dynamic color parameter
  final VoidCallback? onPressed;

  const CustomBackButton({
    super.key,
    this.color = Colors.black, // Default color if none provided
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: color), // Use the provided color
      onPressed: onPressed ?? () => Navigator.pop(context, true),
    );
  }
}