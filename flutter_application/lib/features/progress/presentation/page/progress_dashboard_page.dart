import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/progress_bloc.dart';
import '../widgets/progress_summary_card.dart';
import '../widgets/weekly_adherence_card.dart';
import '../widgets/health_metrics_card.dart';
import '../widgets/workout_performance_card.dart';
import '../widgets/ai_summary_card.dart';
import '../widgets/achievements_card.dart';
import '../../../../core/constants/colors.dart';

import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../dependency_injection.dart';

class ProgressDashboardPage extends StatelessWidget {
  const ProgressDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProgressBloc>()..add(const ProgressLoaded()),
      child: BlocListener<ProgressBloc, ProgressState>(
        listener: (context, state) {
          if (state is ProgressError) {
            context.showErrorSnackBarMessage(state.message);
          }
        },
        child: const _ProgressDashboardView(),
      ),
    );
  }
}

class _ProgressDashboardView extends StatelessWidget {
  const _ProgressDashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Progress Dashboard',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.text),
            onPressed: () {
              context
                  .read<ProgressBloc>()
                  .add(const ProgressRefreshRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<ProgressBloc, ProgressState>(
        builder: (context, state) {
          if (state is ProgressLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (state is ProgressLoadedState) {
            return _buildDashboardContent(context, state.progressData);
          }

          if (state is ProgressError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Failed to load progress data',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.text,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProgressBloc>().add(const ProgressLoaded());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, progressData) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProgressBloc>().add(const ProgressRefreshRequested());
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            ProgressSummaryCard(summary: progressData.summary),
            const SizedBox(height: 16),

            // Weekly Adherence Card
            WeeklyAdherenceCard(adherence: progressData.weeklyAdherence),
            const SizedBox(height: 16),

            // Health Metrics Card
            HealthMetricsCard(healthMetrics: progressData.healthMetrics),
            const SizedBox(height: 16),

            // Workout Performance Card
            WorkoutPerformanceCard(
                performance: progressData.workoutPerformance),
            const SizedBox(height: 16),

            // AI Summary Card
            AISummaryCard(
              aiSummary: progressData.aiSummary,
              onGenerateSummary: () {
                context.read<ProgressBloc>().add(const AISummaryRequested());
              },
            ),
            const SizedBox(height: 16),

            // Achievements Card
            AchievementsCard(achievements: progressData.achievements),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
