import 'package:agpeya/design_preview/design_tokens.dart';
import 'package:flutter/material.dart';

class HomeDesign extends StatelessWidget {
  const HomeDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: DesignTokens.ivory,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Icon(Icons.notifications_none, color: DesignTokens.gold),
                    Text('نوري', style: DesignTokens.heading()),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: DesignTokens.gold),
                      ),
                      child: Center(child: Text('م.ج', style: DesignTokens.ar(12))),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('١٧ بشنس ١٧٤٠', style: DesignTokens.ar(14, DesignTokens.navyMid)),
                const Divider(height: 20),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[DesignTokens.navy, DesignTokens.gold],
                          ),
                          boxShadow: <BoxShadow>[DesignTokens.shadow()],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text('Ⲡⲓⲟⲩⲟⲓ ⲛⲧⲉ ⲡⲁⲛⲟⲩϯ',
                                style: const TextStyle(fontFamily: 'NotoSansCoptic', color: DesignTokens.copticRed)),
                            const SizedBox(height: 8),
                            Text('الرَّبُّ نُورِي وَخَلَاصِي، مَمَّنْ أَخَافُ',
                                style: DesignTokens.ar(20, Colors.white, FontWeight.w700)),
                            const SizedBox(height: 8),
                            Text('The Lord is my light and salvation, whom shall I fear',
                                style: DesignTokens.ui(13, DesignTokens.goldSoft)),
                            const Spacer(),
                            Row(
                              children: <Widget>[
                                FilledButton(
                                  onPressed: () {},
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: DesignTokens.navy,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: Text('ابدأ الصلاة', style: DesignTokens.ar(14)),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.share, color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(alignment: Alignment.centerRight, child: Text('تقدمك اليوم', style: DesignTokens.ar(18))),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List<Widget>.generate(7, (int i) {
                          final bool done = i < 3;
                          return Column(
                            children: <Widget>[
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: done ? DesignTokens.gold : Colors.transparent,
                                  border: Border.all(color: done ? DesignTokens.gold : Colors.grey.shade400),
                                ),
                                child: done ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                              ),
                              const SizedBox(height: 4),
                              Text(i == 0 ? 'بكرة' : '${(i + 1) * 3}', style: DesignTokens.ar(11)),
                            ],
                          );
                        }),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: <Widget>[
                          _stat('🔥', '١٤ يوم', 'سلسلتك'),
                          const SizedBox(width: 8),
                          _stat('🏆', '#٣', 'هذا الأسبوع'),
                          const SizedBox(width: 8),
                          _stat('✨', '٤٥', 'نقاط اليوم'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'الأجبية'),
            BottomNavigationBarItem(icon: Icon(Icons.auto_stories), label: 'الإنجيل'),
            BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'المنافسة'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'ملفي'),
          ],
        ),
      ),
    );
  }

  Widget _stat(String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: <BoxShadow>[DesignTokens.shadow(0.08)],
        ),
        child: Column(
          children: <Widget>[
            Text(emoji),
            Text(value, style: DesignTokens.ar(16, DesignTokens.navy, FontWeight.w700)),
            Text(label, style: DesignTokens.ar(12, Colors.grey.shade700, FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
