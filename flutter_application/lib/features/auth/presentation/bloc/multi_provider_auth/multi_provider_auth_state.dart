import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

enum MultiProviderAuthStatus {
  initial,
  loading,
  success,
  failure,
}

class MultiProviderAuthState extends Equatable {
  const MultiProviderAuthState({
    this.status = MultiProviderAuthStatus.initial,
    this.isAuthenticated = false,
    this.user,
    this.errorMessage,
    this.provider,
  });

  final MultiProviderAuthStatus status;
  final bool isAuthenticated;
  final dynamic user; // User object from Supabase
  final String? errorMessage;
  final String? provider; // 'google', 'apple', 'email'

  MultiProviderAuthState copyWith({
    MultiProviderAuthStatus? status,
    bool? isAuthenticated,
    dynamic user,
    String? errorMessage,
    String? provider,
  }) {
    return MultiProviderAuthState(
      status: status ?? this.status,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      provider: provider ?? this.provider,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isAuthenticated,
        user,
        errorMessage,
        provider,
      ];
}
