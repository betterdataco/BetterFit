part of 'progress_bloc.dart';

abstract class ProgressState extends Equatable {
  const ProgressState();

  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {
  const ProgressInitial();
}

class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

class ProgressLoadedState extends ProgressState {
  const ProgressLoadedState({required this.progressData});

  final ProgressData progressData;

  @override
  List<Object?> get props => [progressData];
}

class AISummaryGenerating extends ProgressState {
  const AISummaryGenerating();
}

class ProgressError extends ProgressState {
  const ProgressError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
