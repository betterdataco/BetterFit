import 'package:flutter/material.dart';
import '../../../../core/constants/spacings.dart';

class OnboardingInputField extends StatefulWidget {
  const OnboardingInputField({
    super.key,
    required this.hint,
    this.keyboardType = TextInputType.text,
    required this.onSubmitted,
    this.validator,
  });

  final String hint;
  final TextInputType keyboardType;
  final Function(String) onSubmitted;
  final String? Function(String?)? validator;

  @override
  State<OnboardingInputField> createState() => _OnboardingInputFieldState();
}

class _OnboardingInputFieldState extends State<OnboardingInputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[600]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[600]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              filled: true,
              fillColor: Colors.grey[900],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Spacing.s16,
                vertical: Spacing.s12,
              ),
            ),
            validator: widget.validator,
            onFieldSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                widget.onSubmitted(value.trim());
                _controller.clear();
              }
            },
          ),
        ),
        const SizedBox(width: Spacing.s8),
        IconButton(
          onPressed: () {
            final value = _controller.text.trim();
            if (value.isNotEmpty) {
              widget.onSubmitted(value);
              _controller.clear();
            }
          },
          icon: const Icon(Icons.send, color: Colors.blue),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey[800],
            padding: const EdgeInsets.all(Spacing.s12),
          ),
        ),
      ],
    );
  }
}
