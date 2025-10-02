import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application/core/constants/spacings.dart';
import 'package:flutter_application/core/constants/colors.dart';

class BetterFitHome extends StatelessWidget {
  const BetterFitHome({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final buttonSize = isMobile ? 140.0 : 180.0;
    final iconSize = isMobile ? 40.0 : 52.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'BetterFit',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        actions: [
          _menuIcon(context, Icons.person, 'My Profile'),
          _menuIcon(context, Icons.bar_chart, 'Progress Dashboard'),
          _menuIcon(context, Icons.sync, 'Sync Health Apps'),
          _menuIcon(context, Icons.smart_toy, 'Ask BetterFit'),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.surface, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.s24),
            child: Column(
              children: [
                // Welcome Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(Spacing.s24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(Spacing.s24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Welcome back! 👋',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: Spacing.s8),
                      Text(
                        'Ready to crush your fitness goals today?',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: Spacing.s32),

                // Main Actions Grid
                Expanded(
                  child: Center(
                    child: Wrap(
                      spacing: Spacing.s16,
                      runSpacing: Spacing.s16,
                      alignment: WrapAlignment.center,
                      children: [
                        _featureButton(
                          context,
                          Icons.restaurant,
                          'Log a Meal',
                          buttonSize,
                          iconSize,
                          AppColors.primary,
                          () => _navigateToMealLogging(context),
                        ),
                        _featureButton(
                          context,
                          Icons.fitness_center,
                          'Exercise Plan',
                          buttonSize,
                          iconSize,
                          AppColors.secondary,
                          () => _navigateToExercisePlan(context),
                        ),
                        _featureButton(
                          context,
                          Icons.receipt_long,
                          'Meal Plan',
                          buttonSize,
                          iconSize,
                          AppColors.tertiary,
                          () => _navigateToMealPlan(context),
                        ),
                        _featureButton(
                          context,
                          Icons.insights,
                          'Progress',
                          buttonSize,
                          iconSize,
                          AppColors.success,
                          () => _navigateToProgress(context),
                        ),
                        _featureButton(
                          context,
                          Icons.store,
                          'Store',
                          buttonSize,
                          iconSize,
                          AppColors.warning,
                          () => _navigateToStore(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuIcon(BuildContext context, IconData icon, String tooltip) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(
          icon,
          color: AppColors.primary,
          size: 24,
        ),
        onPressed: () {
          _handleMenuAction(context, tooltip);
        },
        style: IconButton.styleFrom(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _featureButton(
    BuildContext context,
    IconData icon,
    String label,
    double size,
    double iconSize,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.9),
                    color,
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  const SizedBox(height: Spacing.s12),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'My Profile':
        context.go('/profile');
        break;
      case 'Progress Dashboard':
        context.go('/progress');
        break;
      case 'Sync Health Apps':
        _showSyncHealthApps(context);
        break;
      case 'Ask BetterFit':
        _showAskBetterFit(context);
        break;
    }
  }

  void _navigateToMealLogging(BuildContext context) {
    context.go('/meal-tracking');
  }

  void _navigateToExercisePlan(BuildContext context) {
    context.go('/exercises');
  }

  void _navigateToMealPlan(BuildContext context) {
    context.go('/meal-plan');
  }

  void _navigateToProgress(BuildContext context) {
    context.go('/progress');
  }

  void _navigateToStore(BuildContext context) {
    _showStore(context);
  }

  void _showSyncHealthApps(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Health Apps'),
        content: const Text(
            'Connect your favorite health and fitness apps to sync your data automatically.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement health app sync
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  void _showAskBetterFit(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ask BetterFit'),
        content: const Text(
            'Get personalized fitness advice and answers to your questions from our AI assistant.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement AI chat
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  void _showStore(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('BetterFit Store'),
        content: const Text(
            'Discover premium features, workout plans, and nutrition guides to enhance your fitness journey.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement store navigation
            },
            child: const Text('Browse'),
          ),
        ],
      ),
    );
  }
}
