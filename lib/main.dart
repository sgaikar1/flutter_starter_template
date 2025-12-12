import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/di/service_locator.dart';
import 'core/utils/logger.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await _initializeApp();

  // Create a container for providers
  final container = ProviderContainer();

  // Run app wrapped in ProviderScope
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: App(routerRef: container),
    ),
  );
}

/// Initializes all app dependencies and services
Future<void> _initializeApp() async {
  final logger = AppLogger.app;
  
  try {
    logger.info('Initializing app...');

    // Initialize service locator
    await sl.init();

    logger.info('App initialized successfully');
  } catch (e, stackTrace) {
    logger.fatal(
      'Failed to initialize app',
      error: e,
      stackTrace: stackTrace,
    );
    
    // In production, you might want to show an error screen
    // or report to crash reporting service
    rethrow;
  }
}
