part of 'progress_bloc.dart';

abstract class ProgressEvent extends Equatable {
  const ProgressEvent();

  @override
  List<Object?> get props => [];
}

class ProgressLoaded extends ProgressEvent {
  const ProgressLoaded();
}

class ProgressRefreshRequested extends ProgressEvent {
  const ProgressRefreshRequested();
}

class AISummaryRequested extends ProgressEvent {
  const AISummaryRequested();
}
