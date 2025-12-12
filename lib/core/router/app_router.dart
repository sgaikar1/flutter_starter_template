import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/auth/presentation/pages/login_page.dart';

/// App router configuration using go_router
class AppRouter {
  AppRouter(this._ref);

  final Ref _ref;

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: _handleRedirect,
    refreshListenable: _AuthStateListenable(_ref),
    routes: [
      // Auth routes (unauthenticated)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Main app routes (authenticated)
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const _PlaceholderPage(title: 'Home'),
        routes: [
          GoRoute(
            path: 'detail/:id',
            name: 'detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return _PlaceholderPage(title: 'Detail $id');
            },
          ),
        ],
      ),

      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const _PlaceholderPage(
          title: 'Settings',
        ),
      ),
    ],
    errorBuilder: (context, state) => _ErrorPage(error: state.error),
  );

  /// Handles authentication-based redirects
  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final isAuthenticated = _ref.read(authNotifierProvider.notifier).isAuthenticated;
    final isLoggingIn = state.matchedLocation == '/login';

    // If not authenticated and not on login page, redirect to login
    if (!isAuthenticated && !isLoggingIn) {
      return '/login';
    }

    // If authenticated and on login page, redirect to home
    if (isAuthenticated && isLoggingIn) {
      return '/home';
    }

    // No redirect needed
    return null;
  }
}

/// Listenable wrapper for auth state to trigger router refreshes
class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(this._ref) {
    _ref.listen(authNotifierProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;
}

/// Temporary placeholder page
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title Page\n(TODO: Implement)',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

/// Error page
class _ErrorPage extends StatelessWidget {
  const _ErrorPage({this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                error?.toString() ?? 'Page not found',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
