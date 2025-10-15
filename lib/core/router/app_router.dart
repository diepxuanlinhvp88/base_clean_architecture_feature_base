import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../shared/presentation/pages/home_page.dart';
import '../../shared/presentation/pages/splash_page.dart';

/// Application router configuration
class AppRouter {
  AppRouter._();

  static final GoRouter _router = GoRouter(
    initialLocation: SplashPage.routeName,
    debugLogDiagnostics: true,
    routes: [
      // Splash route
      GoRoute(
        path: SplashPage.routeName,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Authentication routes
      GoRoute(
        path: LoginPage.routeName,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Register Page - To be implemented'),
          ),
        ),
      ),

      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Forgot Password Page - To be implemented'),
          ),
        ),
      ),

      // Main app routes
      GoRoute(
        path: HomePage.routeName,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // Profile routes
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Profile Page - To be implemented'),
          ),
        ),
      ),

      // Settings routes
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Settings Page - To be implemented'),
          ),
        ),
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),

    // Redirect logic
    redirect: (context, state) {
      // Add authentication redirect logic here
      // For now, allow all routes
      return null;
    },
  );

  static GoRouter get router => _router;
}
