import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/spacings.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../user/domain/models/user_profile.dart';
import '../bloc/profile_bloc.dart';

class BasicInfoSection extends StatefulWidget {
  const BasicInfoSection({
    super.key,
    required this.userProfile,
  });

  final UserProfile userProfile;

  @override
  State<BasicInfoSection> createState() => _BasicInfoSectionState();
}

class _BasicInfoSectionState extends State<BasicInfoSection> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name ?? '');
    _ageController = TextEditingController(text: widget.userProfile.age?.toString() ?? '');
    _heightController = TextEditingController(text: widget.userProfile.heightCm?.toString() ?? '');
    _weightController = TextEditingController(text: widget.userProfile.weightKg?.toString() ?? '');
    _selectedGender = widget.userProfile.gender;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.person,
                color: AppColors.primary,
                size: 24,
              ),
              SizedBox(width: Spacing.s8),
              Text(
                'Basic Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.s16),
          
          // Name Field
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person_outline,
            onChanged: (value) => _updateProfile(),
          ),
          
          const SizedBox(height: Spacing.s16),
          
          // Age Field
          _buildTextField(
            controller: _ageController,
            label: 'Age',
            icon: Icons.calendar_today,
            keyboardType: TextInputType.number,
            onChanged: (value) => _updateProfile(),
          ),
          
          const SizedBox(height: Spacing.s16),
          
          // Gender Selection
          _buildGenderSelection(),
          
          const SizedBox(height: Spacing.s16),
          
          // Height Field
          _buildTextField(
            controller: _heightController,
            label: 'Height (cm)',
            icon: Icons.height,
            keyboardType: TextInputType.number,
            onChanged: (value) => _updateProfile(),
          ),
          
          const SizedBox(height: Spacing.s16),
          
          // Weight Field
          _buildTextField(
            controller: _weightController,
            label: 'Weight (kg)',
            icon: Icons.monitor_weight,
            keyboardType: TextInputType.number,
            onChanged: (value) => _updateProfile(),
          ),
          
          const SizedBox(height: Spacing.s16),
          
          // BMI Display
          if (widget.userProfile.bmi != null) _buildBmiDisplay(),
          
          const SizedBox(height: Spacing.s16),
          
          // Import from Health Apps Button
          _buildImportFromHealthButton(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: AppColors.primary),
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
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        filled: true,
        fillColor: AppColors.background,
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: Spacing.s8),
        Wrap(
          spacing: Spacing.s8,
          children: Gender.values.map((gender) {
            final isSelected = _selectedGender == gender;
            return ChoiceChip(
              label: Text(
                gender.name.replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[400],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedGender = selected ? gender : null;
                });
                _updateProfile();
              },
              backgroundColor: AppColors.background,
              selectedColor: AppColors.primary,
              side: BorderSide(color: Colors.grey[600]!),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBmiDisplay() {
    final bmi = widget.userProfile.bmi!;
    final category = widget.userProfile.bmiCategory!;
    
    return Container(
      padding: const EdgeInsets.all(Spacing.s12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.analytics,
            color: AppColors.primary,
          ),
          const SizedBox(width: Spacing.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BMI: ${bmi.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportFromHealthButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          // TODO: Implement health data import
          context.showSnackBarMessage('Health data import coming soon!');
        },
        icon: const Icon(Icons.sync),
        label: const Text('Import from Health Apps'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(vertical: Spacing.s12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _updateProfile() {
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text);
    final height = int.tryParse(_heightController.text);
    final weight = int.tryParse(_weightController.text);

    context.read<ProfileBloc>().add(
      ProfileDataUpdated(
        name: name.isNotEmpty ? name : null,
        age: age,
        gender: _selectedGender,
        heightCm: height,
        weightKg: weight,
      ),
    );
  }
} 