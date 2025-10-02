import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/spacings.dart';
import '../../domain/models/onboarding_data.dart';

class OnboardingSmartInput extends StatelessWidget {
  const OnboardingSmartInput({
    super.key,
    required this.inferredData,
    required this.smartDefaults,
    required this.onAccept,
    required this.onModify,
    this.currentValue,
  });

  final InferredData? inferredData;
  final SmartDefaults? smartDefaults;
  final VoidCallback onAccept;
  final VoidCallback onModify;
  final dynamic currentValue;

  @override
  Widget build(BuildContext context) {
    if (inferredData == null || smartDefaults == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: Spacing.s8),
      padding: const EdgeInsets.all(Spacing.s16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: Spacing.s12),
          _buildInferredData(),
          const SizedBox(height: Spacing.s12),
          _buildConfidenceIndicator(),
          const SizedBox(height: Spacing.s12),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        Icon(
          Icons.psychology,
          color: AppColors.primary,
          size: 20,
        ),
        SizedBox(width: Spacing.s8),
        Text(
          'Smart Suggestions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInferredData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (smartDefaults!.suggestedAge != null)
          _buildDataRow('Age', '${smartDefaults!.suggestedAge} years'),
        if (smartDefaults!.suggestedHeight != null)
          _buildDataRow('Height', '${smartDefaults!.suggestedHeight} cm'),
        if (smartDefaults!.suggestedWeight != null)
          _buildDataRow('Weight', '${smartDefaults!.suggestedWeight} kg'),
        if (smartDefaults!.suggestedFitnessLevel != null)
          _buildDataRow('Fitness Level', 
            smartDefaults!.suggestedFitnessLevel!.name.toUpperCase()),
        if (smartDefaults!.suggestedGoal != null)
          _buildDataRow('Goal', 
            '${smartDefaults!.suggestedGoal!.emoji} ${smartDefaults!.suggestedGoal!.title}'),
      ],
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.s4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceIndicator() {
    final confidence = inferredData!.confidence;
    final confidenceText = _getConfidenceText(confidence);
    final confidenceColor = _getConfidenceColor(confidence);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.s12, vertical: Spacing.s8),
      decoration: BoxDecoration(
        color: confidenceColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: confidenceColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.trending_up,
            color: confidenceColor,
            size: 16,
          ),
          const SizedBox(width: Spacing.s8),
          Text(
            'Confidence: $confidenceText (${(confidence * 100).round()}%)',
            style: TextStyle(
              color: confidenceColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: Spacing.s12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Accept Suggestions',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: Spacing.s12),
        Expanded(
          child: OutlinedButton(
            onPressed: onModify,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.grey),
              padding: const EdgeInsets.symmetric(vertical: Spacing.s12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Modify',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  String _getConfidenceText(double confidence) {
    if (confidence >= 0.8) return 'Very High';
    if (confidence >= 0.6) return 'High';
    if (confidence >= 0.4) return 'Medium';
    if (confidence >= 0.2) return 'Low';
    return 'Very Low';
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    if (confidence >= 0.4) return Colors.yellow;
    return Colors.red;
  }
}

class OnboardingConfidenceBreakdown extends StatelessWidget {
  const OnboardingConfidenceBreakdown({
    super.key,
    required this.confidenceBreakdown,
  });

  final Map<String, double>? confidenceBreakdown;

  @override
  Widget build(BuildContext context) {
    if (confidenceBreakdown == null || confidenceBreakdown!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: Spacing.s8),
      padding: const EdgeInsets.all(Spacing.s12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Sources',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: Spacing.s8),
          ...confidenceBreakdown!.entries.map((entry) => 
            _buildConfidenceRow(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildConfidenceRow(String source, double confidence) {
    final sourceName = _getSourceDisplayName(source);
    final confidencePercentage = (confidence * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.s4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              sourceName,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: confidence,
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getConfidenceColor(confidence),
              ),
            ),
          ),
          const SizedBox(width: Spacing.s8),
          SizedBox(
            width: 40,
            child: Text(
              '$confidencePercentage%',
              style: TextStyle(
                color: _getConfidenceColor(confidence),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSourceDisplayName(String source) {
    switch (source) {
      case 'steps':
        return 'Step Count';
      case 'resting_heart_rate':
        return 'Resting HR';
      case 'workout_history':
        return 'Workouts';
      case 'height':
        return 'Height';
      case 'weight':
        return 'Weight';
      default:
        return source.replaceAll('_', ' ').toUpperCase();
    }
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    if (confidence >= 0.4) return Colors.yellow;
    return Colors.red;
  }
}
