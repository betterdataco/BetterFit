import 'package:flutter/foundation.dart';
import 'package:flutter_application/core/constants/urls.dart';
import 'package:flutter_application/features/auth/data/mapper/auth_mapper.dart';
import 'package:flutter_application/features/auth/domain/entity/auth_user_entity.dart';
import 'package:flutter_application/features/auth/domain/exception/login_with_email_exception.dart';
import 'package:flutter_application/features/auth/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Injectable(as: AuthRepository)
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(
    this._supabaseAuth,
  );

  final GoTrueClient _supabaseAuth;

  @override
  Future<void> loginWithEmail(String email) async {
    try {
      print('Auth: Attempting to send magic link to: $email');
      print('Auth: Is Web: $kIsWeb');

      const redirectUrl = kIsWeb
          ? null // Let Supabase handle the redirect automatically for web
          : Urls.loginCallbackUrl; // For mobile apps

      print('Auth: Redirect URL: $redirectUrl');

      await _supabaseAuth.signInWithOtp(
        email: email,
        emailRedirectTo: redirectUrl,
      );

      print('Auth: Magic link request sent successfully');
    } on AuthException catch (error) {
      print('Auth: Error sending magic link: ${error.message}');
      print('Auth: Error status code: ${error.statusCode}');
      throw LoginWithEmailException(error.message);
    } catch (e) {
      print('Auth: Unexpected error: $e');
      throw const LoginWithEmailException('Unexpected error occurred');
    }
  }

  @override
  Future<void> logout() async {
    await _supabaseAuth.signOut();
  }

  @override
  Stream<AuthState> getCurrentAuthState() {
    return _supabaseAuth.onAuthStateChange.map(
      (authState) => authState,
    );
  }

  @override
  AuthUserEntity? getLoggedInUser() {
    return _supabaseAuth.currentUser?.toUserEntity();
  }
}
