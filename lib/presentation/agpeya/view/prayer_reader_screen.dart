
import 'package:agpeya/core/theme/app_colors.dart';
import 'package:agpeya/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class PrayerReaderScreen extends StatefulWidget {
  const PrayerReaderScreen({
    required this.hourName,
    required this.hour,
    required this.content,
    super.key,
  });
  final String hourName;
  final int hour;
  final List<String> content;

  @override
  State<PrayerReaderScreen> createState() => _PrayerReaderScreenState();
}

class _PrayerReaderScreenState extends State<PrayerReaderScreen> {
  double fontSize = 20;
  bool completing = false;
  bool showSuccess = false;
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> tabs = <String>[l10n.tab_arabic, l10n.tab_english, l10n.tab_coptic];
    final List<String> content = widget.content;
    return Scaffold(
      backgroundColor: AppColors.backgroundNavy,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: Text(
                      widget.hourName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => fontSize = (fontSize + 1).clamp(16, 34)),
                    icon: const Icon(Icons.format_size, color: Colors.white),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border, color: Colors.white)),
                ],
              ),
            ),
            const LinearProgressIndicator(value: 0.28, color: AppColors.primaryGoldDark, minHeight: 3),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List<Widget>.generate(tabs.length, (int index) {
                final bool active = selectedTab == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedTab = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: active ? AppColors.primaryGoldDark : Colors.transparent,
                      border: Border.all(color: AppColors.primaryGoldDark),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w700,
                        color: active ? Colors.white : AppColors.primaryGoldDark,
                      ),
                    ),
                  ),
                );
              }),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 16),
                    Text(
                      content[selectedTab],
                      textAlign: selectedTab == 0 ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        fontFamily: selectedTab == 2 ? 'NotoSansCoptic' : (selectedTab == 0 ? 'Cairo' : 'PlayfairDisplay'),
                        fontSize: selectedTab == 2 ? fontSize - 2 : fontSize,
                        color: selectedTab == 0 ? AppColors.backgroundIvory : (selectedTab == 1 ? AppColors.goldSoft : AppColors.copticRed),
                        height: selectedTab == 0 ? 1.8 : 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            if (showSuccess)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('+10 نقاط', style: TextStyle(fontFamily: 'Cairo', fontSize: 20, color: AppColors.primaryGoldLight)),
              ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[AppColors.primaryGoldLight, AppColors.primaryGoldDark]),
                ),
                child: TextButton(
                  onPressed: completing
                      ? null
                      : () async {
                          final NavigatorState navigator = Navigator.of(context);
                          setState(() => completing = true);
                          await Future<void>.delayed(const Duration(milliseconds: 450));
                          if (!mounted) return;
                          setState(() {
                            showSuccess = true;
                            completing = false;
                          });
                          await Future<void>.delayed(const Duration(milliseconds: 600));
                          if (!mounted) return;
                          navigator.pop<bool>(true);
                        },
                  child: Text(
                    '✓ ${l10n.mark_complete_btn} — +١٠ نقاط',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: AppColors.navyMid,
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    ),
                    child: const Text('١×', style: TextStyle(color: Colors.white, fontFamily: 'Cairo')),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Slider(
                          value: fontSize,
                          min: 16,
                          max: 32,
                          activeColor: AppColors.primaryGoldDark,
                          inactiveColor: AppColors.backgroundNavy,
                          onChanged: (double v) => setState(() => fontSize = v),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: <Widget>[
                              Text('00:45', style: TextStyle(color: Colors.white, fontSize: 11)),
                              Spacer(),
                              Text('09:12', style: TextStyle(color: Colors.white, fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryGoldDark,
                    child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
