import 'package:agpeya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.church, size: 88),
              const SizedBox(height: 16),
              Text(l10n.onboarding_welcome, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/login'),
                child: Text(l10n.onboarding_start),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
