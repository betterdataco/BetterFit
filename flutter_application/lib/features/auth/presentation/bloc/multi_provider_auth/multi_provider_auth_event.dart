import 'package:equatable/equatable.dart';

abstract class MultiProviderAuthEvent extends Equatable {
  const MultiProviderAuthEvent();

  @override
  List<Object?> get props => [];
}

class MultiProviderAuthGoogleSignInRequested extends MultiProviderAuthEvent {
  const MultiProviderAuthGoogleSignInRequested();
}

class MultiProviderAuthAppleSignInRequested extends MultiProviderAuthEvent {
  const MultiProviderAuthAppleSignInRequested();
}

class MultiProviderAuthEmailSignInRequested extends MultiProviderAuthEvent {
  const MultiProviderAuthEmailSignInRequested({
    required this.email,
  });

  final String email;

  @override
  List<Object?> get props => [email];
}

class MultiProviderAuthSignOutRequested extends MultiProviderAuthEvent {
  const MultiProviderAuthSignOutRequested();
}

class MultiProviderAuthStatusChanged extends MultiProviderAuthEvent {
  const MultiProviderAuthStatusChanged({
    required this.isAuthenticated,
    required this.user,
  });

  final bool isAuthenticated;
  final dynamic user; // User object from Supabase

  @override
  List<Object?> get props => [isAuthenticated, user];
}
