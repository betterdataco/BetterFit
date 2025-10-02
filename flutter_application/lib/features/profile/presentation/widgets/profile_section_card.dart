import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/spacings.dart';
import '../../domain/models/profile_section.dart';

class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({
    super.key,
    required this.section,
    required this.isSelected,
    required this.onTap,
  });

  final ProfileSectionItem section;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: section.isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.s16),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(Spacing.s8),
                decoration: BoxDecoration(
                  color: section.isEnabled 
                    ? AppColors.primary.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  section.section.icon,
                  color: section.isEnabled ? AppColors.primary : Colors.grey,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: Spacing.s12),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            section.section.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: section.isEnabled ? Colors.white : Colors.grey,
                            ),
                          ),
                        ),
                        if (section.badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.s8,
                              vertical: Spacing.s4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              section.badge!,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: Spacing.s4),
                    Text(
                      section.section.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: section.isEnabled ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow
              if (section.isEnabled)
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
} 