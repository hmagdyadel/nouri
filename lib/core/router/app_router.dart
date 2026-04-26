import 'package:agpeya/design_preview/design_router.dart';
import 'package:agpeya/presentation/shared/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            _buildPage(const AppScaffold()),
      ),
      GoRoute(
        path: '/design-preview',
        pageBuilder: (BuildContext context, GoRouterState state) =>
            _buildPage(const DesignRouter()),
      ),
    ],
  );

  static CustomTransitionPage<void> _buildPage(Widget child) {
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
