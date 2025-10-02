import 'package:flutter/material.dart';

class BaseTextField extends StatelessWidget {
  const BaseTextField({
    super.key,
    required this.labelText,
    required this.onChanged,
    required this.textInputAction,
    required this.keyboardType,
    this.helperText,
    this.errorText,
  });

  final Function(String) onChanged;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String labelText;
  final String? errorText;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[600]),
        helperText: helperText,
        helperStyle: TextStyle(color: Colors.grey[500]),
        errorText: errorText,
        errorStyle: const TextStyle(color: Colors.red),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
