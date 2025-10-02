import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application/core/extensions/hive_extensions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application/core/services/environment_service.dart';

import 'package:flutter_application/core/app/app.dart';
import 'package:flutter_application/dependency_injection.dart';

void main() async {
  print('BetterFit app starting...');
  WidgetsFlutterBinding.ensureInitialized();
  print('Flutter binding initialized');

  try {
    await _initializeEnvironment();
    print('Environment initialized');

    await _initializeSupabase();
    print('Supabase initialized');

    await _initializeHive();
    print('Hive initialized');

    configureDependencyInjection();
    print('Dependency injection configured');

    print('Starting Flutter app...');
    runApp(
      const FlutterSupabaseStarterApp(),
    );
    print('Flutter app started successfully');
  } catch (e, stackTrace) {
    print('Error during app initialization: $e');
    print('Stack trace: $stackTrace');
    // Still try to run the app even if some services fail
    runApp(
      const FlutterSupabaseStarterApp(),
    );
  }
}

Future<void> _initializeSupabase() async {
  try {
    // Use environment service for all platforms
    final supabaseUrl = EnvironmentService.supabaseUrl;
    final supabaseAnonKey = EnvironmentService.supabaseAnonKey;

    print('Supabase URL: ${supabaseUrl.isNotEmpty ? 'Set' : 'Not set'}');
    print(
        'Supabase Anon Key: ${supabaseAnonKey.isNotEmpty ? 'Set' : 'Not set'}');

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      print(
          'Warning: Supabase credentials not found. App may not function properly.');
    }

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        autoRefreshToken: true,
      ),
    );
    print('Supabase initialized successfully');
  } catch (e) {
    print('Failed to initialize Supabase: $e');
    // Continue without Supabase for now
  }
}

Future<void> _initializeEnvironment() async {
  try {
    // Use environment service for all platforms
    await EnvironmentService.initialize();
  } catch (e) {
    print('Error initializing environment: $e');
    // Continue without environment service
  }
}

Future<void> _initializeHive() async {
  try {
    await Hive.initFlutter();
    await Hive.openThemeModeBox();
  } catch (e) {
    print('Failed to initialize Hive: $e');
    // Continue without Hive for now
  }
}
