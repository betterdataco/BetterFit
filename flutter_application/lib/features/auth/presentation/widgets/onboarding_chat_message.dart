import 'package:flutter/material.dart';
import '../../../../core/constants/spacings.dart';

class OnboardingChatMessage extends StatelessWidget {
  const OnboardingChatMessage({
    super.key,
    required this.isUser,
    required this.message,
    this.timestamp,
  });

  final bool isUser;
  final String message;
  final DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.s12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[800],
              child: const Icon(
                Icons.fitness_center,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: Spacing.s8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.s12,
                vertical: Spacing.s8,
              ),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[600] : Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: Spacing.s8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[600],
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
