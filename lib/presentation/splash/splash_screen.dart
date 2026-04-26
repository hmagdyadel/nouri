import 'dart:math' as math;

import 'package:agpeya/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _nameController;
  late final AnimationController _taglineController;
  late final AnimationController _dotsController;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _nameFade;
  late final Animation<double> _taglineFade;
  late final Animation<double> _dotsFade;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // Step 1 — Logo (FadeIn + ScaleIn, 600ms)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _logoFade = CurvedAnimation(parent: _logoController, curve: Curves.easeOut);
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    // Step 2 — App name (FadeIn, delay 600ms, 400ms)
    _nameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _nameFade = CurvedAnimation(parent: _nameController, curve: Curves.easeOut);

    // Step 3 — Tagline (FadeIn, delay 1000ms, 400ms)
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _taglineFade =
        CurvedAnimation(parent: _taglineController, curve: Curves.easeOut);

    // Step 4 — Loading dots (FadeIn, delay 1200ms)
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _dotsFade = CurvedAnimation(parent: _dotsController, curve: Curves.easeOut);

    _startSequence();
  }

  Future<void> _startSequence() async {
    // Step 1: logo at 0ms
    _logoController.forward();

    // Step 2: name at 600ms
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    _nameController.forward();

    // Step 3: tagline at 1000ms
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _taglineController.forward();

    // Step 4: dots at 1200ms
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _dotsController.forward();

    // Navigate after 2500ms total
    await Future<void>.delayed(const Duration(milliseconds: 1300));
    if (!mounted) return;
    await _navigate();
  }

  Future<void> _navigate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool onboardingDone =
        prefs.getString('onboarding_complete') != null;
    if (!mounted) return;
    if (onboardingDone) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _nameController.dispose();
    _taglineController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFF0D1B2A),
              Color(0xFF1A2E45),
              Color(0xFF243B55),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(flex: 3),

            // Step 1 — Logo
            FadeTransition(
              opacity: _logoFade,
              child: ScaleTransition(
                scale: _logoScale,
                child: SizedBox(
                  width: 140,
                  height: 140,
                  child: CustomPaint(painter: _CopticCrossLogoPainter()),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Step 2 — App name
            FadeTransition(
              opacity: _nameFade,
              child: const Column(
                children: <Widget>[
                  Text(
                    'نوري',
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'NOURI',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.goldSoft,
                      letterSpacing: 6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Step 3 — Tagline
            FadeTransition(
              opacity: _taglineFade,
              child: Text(
                'الرَّبُّ نُورِي وَخَلَاصِي',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Step 4 — Loading dots
            FadeTransition(
              opacity: _dotsFade,
              child: const _BouncingDots(),
            ),

            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}

/// Coptic cross logo painter for splash screen
class _CopticCrossLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = 60;

    // Golden glow shadow
    final Paint glowPaint = Paint()
      ..color = AppColors.primaryGoldLight.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, radius + 8, glowPaint);

    // Outer circle — navy background
    final Paint circleFill = Paint()..color = const Color(0xFF0D1B2A);
    canvas.drawCircle(center, radius, circleFill);

    // Outer circle — gold border
    final Paint circleBorder = Paint()
      ..style = PaintingStyle.stroke
      ..color = AppColors.primaryGoldLight
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, circleBorder);

    // Cross bars
    final Paint crossPaint = Paint()
      ..color = AppColors.primaryGoldLight
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    // Vertical bar: 70px tall
    canvas.drawLine(
      Offset(center.dx, center.dy - 35),
      Offset(center.dx, center.dy + 35),
      crossPaint,
    );

    // Horizontal bar: 44px wide, at 30% from top of vertical
    final double horizY = center.dy - 35 + (70 * 0.30);
    canvas.drawLine(
      Offset(center.dx - 22, horizY),
      Offset(center.dx + 22, horizY),
      crossPaint,
    );

    // Small oval loop at top
    final Paint loopPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = AppColors.primaryGoldLight
      ..strokeWidth = 2;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - 35 - 9),
        width: 18,
        height: 13,
      ),
      loopPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Three bouncing gold dots
class _BouncingDots extends StatefulWidget {
  const _BouncingDots();

  @override
  State<_BouncingDots> createState() => _BouncingDotsState();
}

class _BouncingDotsState extends State<_BouncingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Widget>.generate(3, (int index) {
            // Stagger each dot by 150ms (0.125 of 1200ms)
            final double delay = index * 0.125;
            final double t =
                ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
            final double bounce = math.sin(t * math.pi) * 8;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.translate(
                offset: Offset(0, -bounce),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGoldLight,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
