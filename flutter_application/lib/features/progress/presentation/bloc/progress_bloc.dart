import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/progress_repository.dart';
import '../../domain/models/progress_data.dart';

part 'progress_event.dart';
part 'progress_state.dart';

@injectable
class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  ProgressBloc(this._progressRepository) : super(const ProgressInitial()) {
    on<ProgressLoaded>(_onProgressLoaded);
    on<ProgressRefreshRequested>(_onProgressRefreshRequested);
    on<AISummaryRequested>(_onAISummaryRequested);
  }

  final ProgressRepository _progressRepository;

  Future<void> _onProgressLoaded(
    ProgressLoaded event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      emit(const ProgressLoading());

      final progressData = await _progressRepository.getProgressData();

      emit(ProgressLoadedState(progressData: progressData));
    } catch (e) {
      emit(ProgressError('Failed to load progress data: $e'));
    }
  }

  Future<void> _onProgressRefreshRequested(
    ProgressRefreshRequested event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      if (state is ProgressLoadedState) {
        emit(const ProgressLoading());

        final progressData = await _progressRepository.getProgressData();

        emit(ProgressLoadedState(progressData: progressData));
      }
    } catch (e) {
      emit(ProgressError('Failed to refresh progress data: $e'));
    }
  }

  Future<void> _onAISummaryRequested(
    AISummaryRequested event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      emit(const AISummaryGenerating());

      final aiSummary = await _progressRepository.generateAISummary();

      if (state is ProgressLoadedState) {
        final currentState = state as ProgressLoadedState;
        final updatedProgressData = ProgressData(
          summary: currentState.progressData.summary,
          weeklyAdherence: currentState.progressData.weeklyAdherence,
          healthMetrics: currentState.progressData.healthMetrics,
          workoutPerformance: currentState.progressData.workoutPerformance,
          aiSummary: aiSummary,
          achievements: currentState.progressData.achievements,
        );

        emit(ProgressLoadedState(progressData: updatedProgressData));
      }
    } catch (e) {
      emit(ProgressError('Failed to generate AI summary: $e'));
    }
  }
}
