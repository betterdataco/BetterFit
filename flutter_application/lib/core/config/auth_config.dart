import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthConfig {
  // Google Sign-In Configuration
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '',
  );
  
  static const String googleAndroidClientId = String.fromEnvironment(
    'GOOGLE_ANDROID_CLIENT_ID',
    defaultValue: '',
  );
  
  static const String googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue: '',
  );

  // Apple Sign-In Configuration
  static const String appleClientId = String.fromEnvironment(
    'APPLE_CLIENT_ID',
    defaultValue: '',
  );
  
  static const String appleServiceId = String.fromEnvironment(
    'APPLE_SERVICE_ID',
    defaultValue: '',
  );

  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  // Platform-specific client ID getter
  static String get googleClientId {
    if (kIsWeb) {
      return googleWebClientId;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return googleAndroidClientId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return googleIosClientId;
    }
    return googleWebClientId; // fallback
  }

  // Check if Google Sign-In is configured
  static bool get isGoogleSignInConfigured {
    return googleWebClientId.isNotEmpty && 
           googleAndroidClientId.isNotEmpty && 
           googleIosClientId.isNotEmpty;
  }

  // Check if Apple Sign-In is configured
  static bool get isAppleSignInConfigured {
    return appleClientId.isNotEmpty && appleServiceId.isNotEmpty;
  }

  // Check if Supabase is configured
  static bool get isSupabaseConfigured {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }
}
