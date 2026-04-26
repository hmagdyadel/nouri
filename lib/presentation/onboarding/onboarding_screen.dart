import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:agpeya/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  int _index = 0;
  late final AnimationController _fallbackController;

  final List<_OnboardingPageData> _pages = <_OnboardingPageData>[
    _OnboardingPageData(
      lottieUrl: 'https://assets10.lottiefiles.com/packages/lf20_uu0x8lqv.json',
      gradient: const <Color>[Color(0xFF0D1B2A), Color(0xFF1A2E45), Color(0xFF243B55)],
      tagText: 'مرحباً بك',
      title: 'نوري',
      subtitle: 'وَخَلَاصِي',
      bodyLine1: 'الرَّبُّ نُورِي وَخَلَاصِي، مَمَّنْ أَخَافُ',
      bodyLine2: 'مزمور ٢٧: ١',
      fallback: _FallbackType.cross,
    ),
    _OnboardingPageData(
      lottieUrl: 'https://assets3.lottiefiles.com/packages/lf20_myejiggj.json',
      gradient: const <Color>[Color(0xFF1A0A0A), Color(0xFF3D1515), Color(0xFF8B2020)],
      tagText: 'الأجبية المقدسة',
      title: 'صلوات الساعات السبع',
      subtitle: '',
      bodyLine1: 'صلِّ مع الكنيسة في كل ساعة من ساعات النهار والليل',
      bodyLine2: 'واجعل حياتك كلها صلاةً لله',
      chips: const <String>['🌅 بكرة', '☀️ الثالثة', '🌙 نصف الليل'],
      fallback: _FallbackType.candles,
    ),
    _OnboardingPageData(
      lottieUrl: 'https://assets5.lottiefiles.com/packages/lf20_touohxv0.json',
      gradient: const <Color>[Color(0xFF0A1628), Color(0xFF0D2137), Color(0xFF1B3A5C)],
      tagText: 'تحدَّ نفسك',
      title: 'تنافس مع العائلة\nوالكنيسة',
      subtitle: '',
      bodyLine1: 'تتجدد المنافسة كل أسبوع وكل شهر',
      bodyLine2: 'واجعل الصلاة عادة يومية مع من تحب',
      chips: const <String>['🌍 عالمي', '🏛️ كنيستك', '👨‍👩‍👧 عائلتك'],
      fallback: _FallbackType.trophy,
    ),
    _OnboardingPageData(
      lottieUrl: 'https://assets4.lottiefiles.com/packages/lf20_jcikwtux.json',
      gradient: const <Color>[Color(0xFF0D1B2A), Color(0xFF1A2E45), Color(0xFFB8860B)],
      stops: const <double>[0, 0.6, 1],
      tagText: '',
      title: 'ابدأ رحلتك\nمع نوري اليوم',
      subtitle: '',
      bodyLine1: 'لا تحتاج لحساب لتبدأ الصلاة',
      bodyLine2: 'فقط افتح التطبيق وابدأ',
      fallback: _FallbackType.sunrise,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fallbackController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fallbackController.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('onboarding_complete', 'true');
    if (!mounted) return;
    context.go('/home');
  }

  Future<void> _next() async {
    if (_index >= _pages.length - 1) {
      await _complete();
      return;
    }
    await _pageController.animateToPage(
      _index + 1,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _OnboardingPageData page = _pages[_index];
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: AnimatedBuilder(
          animation: _pageController,
          builder: (BuildContext context, Widget? child) {
            final double pageValue = _pageController.hasClients
                ? (_pageController.page ?? _index.toDouble())
                : _index.toDouble();
            final _GradientFrame gradient = _gradientFor(pageValue);
            return DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: gradient.colors,
                  stops: gradient.stops,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (int i) => setState(() => _index = i),
                    itemCount: _pages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final _OnboardingPageData p = _pages[index];
                      final double delta = index - pageValue;
                      final double absDelta = delta.abs().clamp(0, 1);
                      return Opacity(
                        opacity: 1 - (absDelta * 0.35),
                        child: Transform.translate(
                          offset: Offset(delta * 34, 0),
                          child: _OnboardingPage(
                            data: p,
                            animation: _fallbackController,
                            isLast: index == _pages.length - 1,
                            onComplete: _complete,
                            parallax: delta,
                            backgroundOverlayOpacity: 0.08 + (absDelta * 0.12),
                          ),
                        ),
                      );
                    },
                  ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(_pages.length, (int i) {
                          final bool active = i == _index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOutCubic,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: active ? 32 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: active
                                  ? AppColors.primaryGoldDark
                                  : Colors.white.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 10),
                      if (_index < 3)
                        Row(
                          children: <Widget>[
                            TextButton(
                              onPressed: _complete,
                              child: Text(
                                'تخطي',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: _next,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGoldDark,
                                foregroundColor: AppColors.backgroundNavy,
                              ),
                              child: const Text(
                                'التالي',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        const SizedBox(height: 42),
                    ],
                  ),
                ),
              ),
            ),
                  if (page.title.isNotEmpty) const SizedBox.shrink(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _GradientFrame _gradientFor(double pageValue) {
    final int fromIndex = pageValue.floor().clamp(0, _pages.length - 1);
    final int toIndex = pageValue.ceil().clamp(0, _pages.length - 1);
    final double t = (pageValue - fromIndex).clamp(0, 1);
    final _OnboardingPageData from = _pages[fromIndex];
    final _OnboardingPageData to = _pages[toIndex];
    final int maxLen = math.max(from.gradient.length, to.gradient.length);

    final List<Color> colors = List<Color>.generate(maxLen, (int i) {
      final Color c1 = from.gradient[i.clamp(0, from.gradient.length - 1)];
      final Color c2 = to.gradient[i.clamp(0, to.gradient.length - 1)];
      return Color.lerp(c1, c2, t) ?? c1;
    });

    final List<double> s1 = from.stops ?? _defaultStops(from.gradient.length);
    final List<double> s2 = to.stops ?? _defaultStops(to.gradient.length);
    final List<double> stops = List<double>.generate(maxLen, (int i) {
      final double a = s1[i.clamp(0, s1.length - 1)];
      final double b = s2[i.clamp(0, s2.length - 1)];
      return lerpDouble(a, b, t)!;
    });
    return _GradientFrame(colors: colors, stops: stops);
  }

  List<double> _defaultStops(int len) {
    if (len <= 1) return const <double>[0];
    return List<double>.generate(len, (int i) => i / (len - 1));
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.data,
    required this.animation,
    required this.isLast,
    required this.onComplete,
    required this.parallax,
    required this.backgroundOverlayOpacity,
  });

  final _OnboardingPageData data;
  final Animation<double> animation;
  final bool isLast;
  final Future<void> Function() onComplete;
  final double parallax;
  final double backgroundOverlayOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: backgroundOverlayOpacity),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 45,
            child: Transform.translate(
              offset: Offset(parallax * -30, 0),
              child: Center(
                child: LottieBuilder.network(
                  data.lottieUrl,
                  width: 280,
                  height: 280,
                  fit: BoxFit.contain,
                  repeat: true,
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    return _FallbackIllustration(type: data.fallback, animation: animation);
                  },
                  frameBuilder: (context, child, composition) {
                    if (composition == null) {
                      return const SizedBox(
                        width: 280,
                        height: 280,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryGoldLight,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    }
                    return child;
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 55,
            child: Transform.translate(
              offset: Offset(parallax * 18, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  if (data.tagText.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: data.fallback == _FallbackType.candles
                            ? AppColors.copticRed
                            : Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        data.tagText,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: data.fallback == _FallbackType.candles
                              ? Colors.white
                              : AppColors.backgroundNavy,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 14),
                  Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (data.subtitle.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 8),
                    Text(
                      data.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: AppColors.goldSoft,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    data.bodyLine1,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.bodyLine2,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: AppColors.goldSoft,
                    ),
                  ),
                  if (data.chips.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 12),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: data.chips
                          .map((String e) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundIvory,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    color: AppColors.backgroundNavy,
                                    fontSize: 12,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                    if (isLast) ...<Widget>[
                    const SizedBox(height: 18),
                    Row(
                      children: const <Widget>[
                        Icon(Icons.check_circle, color: AppColors.primaryGoldDark, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'الأجبية الكاملة بالعربي والإنجليزي والقبطي',
                            style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const <Widget>[
                        Icon(Icons.check_circle, color: AppColors.primaryGoldDark, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'بطاقات يومية قابلة للمشاركة',
                            style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const <Widget>[
                        Icon(Icons.check_circle, color: AppColors.primaryGoldDark, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'منافسات أسبوعية وشهرية مع كنيستك',
                            style: TextStyle(fontFamily: 'Cairo', color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: <Color>[AppColors.primaryGoldDark, AppColors.primaryGoldLight],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppColors.primaryGoldDark.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: onComplete,
                          child: const Text(
                            'ابدأ الآن ←',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onComplete,
                      child: Text(
                        'تخطي',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FallbackIllustration extends StatelessWidget {
  const _FallbackIllustration({required this.type, required this.animation});
  final _FallbackType type;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290,
      height: 290,
      child: AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) => CustomPaint(
          painter: _OnboardingFallbackPainter(type: type, t: animation.value),
        ),
      ),
    );
  }
}

class _OnboardingFallbackPainter extends CustomPainter {
  _OnboardingFallbackPainter({required this.type, required this.t});
  final _FallbackType type;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case _FallbackType.cross:
        _drawCross(canvas, size);
      case _FallbackType.candles:
        _drawCandles(canvas, size);
      case _FallbackType.trophy:
        _drawTrophy(canvas, size);
      case _FallbackType.sunrise:
        _drawSunrise(canvas, size);
    }
  }

  void _drawCross(Canvas canvas, Size s) {
    final Offset c = Offset(s.width / 2, s.height / 2);
    final Paint glow = Paint()
      ..shader = RadialGradient(
        colors: <Color>[
          AppColors.primaryGoldLight.withValues(alpha: 0.25 + (0.35 * t)),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: c, radius: 130));
    canvas.drawCircle(c, 130, glow);

    final Paint cross = Paint()
      ..color = AppColors.primaryGoldLight
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;
    canvas.drawLine(Offset(c.dx, c.dy - 80), Offset(c.dx, c.dy + 80), cross);
    canvas.drawLine(Offset(c.dx - 50, c.dy - 25), Offset(c.dx + 50, c.dy - 25), cross);
    final Paint loop = Paint()
      ..style = PaintingStyle.stroke
      ..color = AppColors.primaryGoldLight
      ..strokeWidth = 3;
    canvas.drawOval(Rect.fromCenter(center: Offset(c.dx, c.dy - 92), width: 28, height: 20), loop);

    final List<Offset> dots = <Offset>[
      const Offset(30, 26),
      const Offset(70, 38),
      const Offset(250, 40),
      const Offset(240, 86),
      const Offset(44, 250),
      const Offset(90, 234),
      const Offset(220, 240),
      const Offset(256, 210),
      const Offset(160, 52),
      const Offset(186, 80),
      const Offset(112, 212),
      const Offset(192, 190),
    ];
    for (int i = 0; i < dots.length; i++) {
      canvas.drawCircle(
        dots[i],
        3 + (i % 6).toDouble(),
        Paint()..color = AppColors.primaryGoldLight.withValues(alpha: 0.35),
      );
    }
  }

  void _drawCandles(Canvas canvas, Size s) {
    final Offset c = Offset(s.width / 2, s.height / 2);
    canvas.drawCircle(
      c,
      120,
      Paint()
        ..shader = RadialGradient(colors: <Color>[
          AppColors.copticRed.withValues(alpha: 0.35),
          Colors.transparent,
        ]).createShader(Rect.fromCircle(center: c, radius: 120)),
    );
    for (int i = 0; i < 7; i++) {
      final double dx = c.dx - 90 + (i * 30);
      final double h = 28 + (i == 3 ? 18 : (i % 2 == 0 ? 8 : 0));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(dx, c.dy + 35 - h, 8, 40 + h),
          const Radius.circular(4),
        ),
        Paint()..color = Colors.white,
      );
      final Path flame = Path()
        ..moveTo(dx + 4, c.dy - h)
        ..quadraticBezierTo(dx + 1, c.dy - h - 14 - (math.sin((t * 6) + i) * 2), dx + 4, c.dy - h - 22)
        ..quadraticBezierTo(dx + 7, c.dy - h - 14, dx + 4, c.dy - h);
      canvas.drawPath(
        flame,
        Paint()
          ..shader = const LinearGradient(
            colors: <Color>[Color(0xFFFF8A00), Color(0xFFFFD54F), Colors.white],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ).createShader(Rect.fromLTWH(dx, c.dy - h - 24, 8, 24)),
      );
    }
  }

  void _drawTrophy(Canvas canvas, Size s) {
    final Offset c = Offset(s.width / 2, s.height / 2 + (math.sin(t * math.pi * 2) * 8));
    final Rect cup = Rect.fromCenter(center: Offset(c.dx, c.dy - 20), width: 80, height: 90);
    canvas.drawRRect(
      RRect.fromRectAndRadius(cup, const Radius.circular(12)),
      Paint()
        ..shader = const LinearGradient(
          colors: <Color>[AppColors.primaryGoldLight, AppColors.primaryGoldDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(cup),
    );
    final Paint handle = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = AppColors.primaryGoldLight;
    canvas.drawArc(Rect.fromCenter(center: Offset(c.dx - 50, c.dy - 20), width: 30, height: 45), -1.3, 2.3, false, handle);
    canvas.drawArc(Rect.fromCenter(center: Offset(c.dx + 50, c.dy - 20), width: 30, height: 45), 2.1, 2.3, false, handle);
    canvas.drawRect(Rect.fromCenter(center: Offset(c.dx, c.dy + 42), width: 16, height: 24), Paint()..color = AppColors.primaryGoldDark);
    canvas.drawRect(Rect.fromCenter(center: Offset(c.dx, c.dy + 58), width: 80, height: 12), Paint()..color = AppColors.primaryGoldLight);
    final List<Rect> podium = <Rect>[
      Rect.fromLTWH(c.dx - 70, c.dy + 72, 40, 28),
      Rect.fromLTWH(c.dx - 20, c.dy + 62, 40, 38),
      Rect.fromLTWH(c.dx + 30, c.dy + 78, 40, 22),
    ];
    final List<Color> colors = <Color>[Colors.blueGrey.shade300, AppColors.primaryGoldDark, const Color(0xFFB87333)];
    for (int i = 0; i < podium.length; i++) {
      canvas.drawRRect(RRect.fromRectAndRadius(podium[i], const Radius.circular(4)), Paint()..color = colors[i]);
    }
  }

  void _drawSunrise(Canvas canvas, Size s) {
    final Offset sun = Offset(s.width / 2, s.height * 0.72);
    canvas.drawCircle(
      sun,
      80,
      Paint()
        ..shader = RadialGradient(
          colors: <Color>[AppColors.primaryGoldLight.withValues(alpha: 0.8), Colors.transparent],
        ).createShader(Rect.fromCircle(center: sun, radius: 120)),
    );
    canvas.drawArc(
      Rect.fromCircle(center: sun, radius: 80),
      math.pi,
      math.pi,
      true,
      Paint()
        ..shader = const LinearGradient(
          colors: <Color>[AppColors.primaryGoldLight, AppColors.primaryGoldDark],
        ).createShader(Rect.fromCircle(center: sun, radius: 80)),
    );
    for (int i = 0; i < 12; i++) {
      final double a = ((math.pi * 2) / 12) * i + (t * 0.3);
      final Offset p1 = Offset(sun.dx + math.cos(a) * 65, sun.dy + math.sin(a) * 65);
      final Offset p2 = Offset(sun.dx + math.cos(a) * 98, sun.dy + math.sin(a) * 98);
      canvas.drawLine(p1, p2, Paint()..color = AppColors.primaryGoldDark..strokeWidth = 2);
    }
    final Path church = Path()
      ..moveTo(0, s.height)
      ..lineTo(0, s.height - 70)
      ..lineTo(s.width * 0.2, s.height - 70)
      ..lineTo(s.width * 0.3, s.height - 108)
      ..lineTo(s.width * 0.4, s.height - 70)
      ..lineTo(s.width * 0.48, s.height - 70)
      ..lineTo(s.width * 0.5, s.height - 132)
      ..lineTo(s.width * 0.52, s.height - 70)
      ..lineTo(s.width * 0.6, s.height - 70)
      ..lineTo(s.width * 0.7, s.height - 108)
      ..lineTo(s.width * 0.8, s.height - 70)
      ..lineTo(s.width, s.height - 70)
      ..lineTo(s.width, s.height)
      ..close();
    canvas.drawPath(church, Paint()..color = AppColors.backgroundNavy);
  }

  @override
  bool shouldRepaint(covariant _OnboardingFallbackPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.type != type;
}

enum _FallbackType { cross, candles, trophy, sunrise }

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.lottieUrl,
    required this.gradient,
    required this.tagText,
    required this.title,
    required this.subtitle,
    required this.bodyLine1,
    required this.bodyLine2,
    this.stops,
    this.chips = const <String>[],
    required this.fallback,
  });

  final String lottieUrl;
  final List<Color> gradient;
  final List<double>? stops;
  final String tagText;
  final String title;
  final String subtitle;
  final String bodyLine1;
  final String bodyLine2;
  final List<String> chips;
  final _FallbackType fallback;
}

class _GradientFrame {
  const _GradientFrame({required this.colors, required this.stops});
  final List<Color> colors;
  final List<double> stops;
}
