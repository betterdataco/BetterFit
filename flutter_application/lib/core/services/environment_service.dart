import 'package:flutter/foundation.dart';

/// Simple environment service that uses String.fromEnvironment for all platforms
/// This avoids the need for dotenv and prevents .env file loading issues
class EnvironmentService {
  static const String _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String _supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String _usdaFoodDataApiKey =
      String.fromEnvironment('USDA_FOOD_DATA_API_KEY');
  static const bool _isWeb =
      bool.fromEnvironment('IS_WEB', defaultValue: false);

  /// Get Supabase URL
  static String get supabaseUrl => _supabaseUrl;

  /// Get Supabase anonymous key
  static String get supabaseAnonKey => _supabaseAnonKey;

  /// Get USDA Food Data API key
  static String get usdaFoodDataApiKey => _usdaFoodDataApiKey;

  /// Check if running on web
  static bool get isWeb => kIsWeb || _isWeb;

  /// Initialize environment (no-op for this service)
  static Future<void> initialize() async {
    print('EnvironmentService: Initialized');
    print('EnvironmentService: isWeb = $isWeb');
    print(
        'EnvironmentService: supabaseUrl = ${supabaseUrl.isNotEmpty ? 'Set' : 'Not set'}');
    print(
        'EnvironmentService: supabaseAnonKey = ${supabaseAnonKey.isNotEmpty ? 'Set' : 'Not set'}');
    print(
        'EnvironmentService: usdaFoodDataApiKey = ${usdaFoodDataApiKey.isNotEmpty ? 'Set' : 'Not set'}');
  }
}
