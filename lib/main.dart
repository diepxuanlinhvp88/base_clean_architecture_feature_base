import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Main entry point of the application
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize core services
  await _initializeApp();

  runApp(const MyApp());
}

/// Initialize application dependencies and services
Future<void> _initializeApp() async {
  try {
    // Load environment variables (optional, will not fail if file doesn't exist)
    try {
      await dotenv.load(fileName: '.env');
      debugPrint('Environment file loaded successfully');
    } catch (e) {
      // Environment file not found, using default values
      debugPrint('Environment file not found, using default values');
    }

    // Initialize Hive for local storage
    await Hive.initFlutter();

    // Configure dependency injection
    await configureDependencies();

    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Error initializing app: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}

/// Root application widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Clean Architecture Flutter',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // Router configuration
      routerConfig: AppRouter.router,
      
      // Localization (can be extended later)
      // locale: const Locale('en', 'US'),
      // supportedLocales: const [
      //   Locale('en', 'US'),
      //   Locale('vi', 'VN'),
      // ],
      
      // Builder for additional configuration
      builder: (context, child) {
        return MediaQuery(
          // Prevent font scaling beyond reasonable limits
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
