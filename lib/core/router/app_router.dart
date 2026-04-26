import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/design_preview/design_router.dart';
import 'package:agpeya/presentation/onboarding/onboarding_screen.dart';
import 'package:agpeya/presentation/shared/app_scaffold.dart';
import 'package:agpeya/presentation/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter createRouter() => GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            _buildPage(const SplashScreen()),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            _buildPage(const AppScaffold()),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            _buildPage(const OnboardingScreen()),
      ),
      GoRoute(
        path: '/design-preview',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            _buildPage(const DesignRouter()),
      ),
    ],
  );

  static CustomTransitionPage<void> _buildPage(Widget child) {
    AppLogger.navigation('Navigating to ${child.runtimeType}');
    return CustomTransitionPage<void>(
      child: child,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        final Animation<Offset> slide = Tween<Offset>(
          begin: const Offset(0.05, 0.02),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
    );
  }
}
