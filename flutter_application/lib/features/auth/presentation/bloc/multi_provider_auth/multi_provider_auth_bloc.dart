import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../data/services/multi_provider_auth_service.dart';
import 'multi_provider_auth_event.dart';
import 'multi_provider_auth_state.dart';

@injectable
class MultiProviderAuthBloc extends Bloc<MultiProviderAuthEvent, MultiProviderAuthState> {
  MultiProviderAuthBloc(this._authService) : super(const MultiProviderAuthState()) {
    on<MultiProviderAuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<MultiProviderAuthAppleSignInRequested>(_onAppleSignInRequested);
    on<MultiProviderAuthEmailSignInRequested>(_onEmailSignInRequested);
    on<MultiProviderAuthSignOutRequested>(_onSignOutRequested);
    on<MultiProviderAuthStatusChanged>(_onAuthStatusChanged);

    // Listen to auth state changes
    _authService.authStateChanges.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      if (event == AuthChangeEvent.signedIn && session != null) {
        add(MultiProviderAuthStatusChanged(
          isAuthenticated: true,
          user: session.user,
        ));
      } else if (event == AuthChangeEvent.signedOut) {
        add(MultiProviderAuthStatusChanged(
          isAuthenticated: false,
          user: null,
        ));
      }
    });
  }

  final MultiProviderAuthService _authService;

  Future<void> _onGoogleSignInRequested(
    MultiProviderAuthGoogleSignInRequested event,
    Emitter<MultiProviderAuthState> emit,
  ) async {
    emit(state.copyWith(
      status: MultiProviderAuthStatus.loading,
      provider: 'google',
    ));

    try {
      final response = await _authService.signInWithGoogle();
      
      if (response.user != null) {
        emit(state.copyWith(
          status: MultiProviderAuthStatus.success,
          isAuthenticated: true,
          user: response.user,
          provider: 'google',
        ));
      } else {
        emit(state.copyWith(
          status: MultiProviderAuthStatus.failure,
          errorMessage: 'Google sign-in failed: No user returned',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: MultiProviderAuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onAppleSignInRequested(
    MultiProviderAuthAppleSignInRequested event,
    Emitter<MultiProviderAuthState> emit,
  ) async {
    emit(state.copyWith(
      status: MultiProviderAuthStatus.loading,
      provider: 'apple',
    ));

    try {
      final response = await _authService.signInWithApple();
      
      if (response.user != null) {
        emit(state.copyWith(
          status: MultiProviderAuthStatus.success,
          isAuthenticated: true,
          user: response.user,
          provider: 'apple',
        ));
      } else {
        emit(state.copyWith(
          status: MultiProviderAuthStatus.failure,
          errorMessage: 'Apple sign-in failed: No user returned',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: MultiProviderAuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onEmailSignInRequested(
    MultiProviderAuthEmailSignInRequested event,
    Emitter<MultiProviderAuthState> emit,
  ) async {
    emit(state.copyWith(
      status: MultiProviderAuthStatus.loading,
      provider: 'email',
    ));

    try {
      final response = await _authService.signInWithEmail(event.email);
      
      emit(state.copyWith(
        status: MultiProviderAuthStatus.success,
        provider: 'email',
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MultiProviderAuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSignOutRequested(
    MultiProviderAuthSignOutRequested event,
    Emitter<MultiProviderAuthState> emit,
  ) async {
    try {
      await _authService.signOut();
      emit(state.copyWith(
        status: MultiProviderAuthStatus.success,
        isAuthenticated: false,
        user: null,
        provider: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: MultiProviderAuthStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onAuthStatusChanged(
    MultiProviderAuthStatusChanged event,
    Emitter<MultiProviderAuthState> emit,
  ) {
    emit(state.copyWith(
      isAuthenticated: event.isAuthenticated,
      user: event.user,
    ));
  }
}
