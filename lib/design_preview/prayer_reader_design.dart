import 'package:agpeya/design_preview/design_tokens.dart';
import 'package:flutter/material.dart';

class PrayerReaderDesign extends StatelessWidget {
  const PrayerReaderDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: DesignTokens.navy,
        appBar: AppBar(
          backgroundColor: DesignTokens.navy,
          foregroundColor: Colors.white,
          title: Text('صلاة باكر', style: DesignTokens.heading(Colors.white)),
          centerTitle: true,
          actions: const <Widget>[Padding(padding: EdgeInsets.all(12), child: Icon(Icons.text_fields))],
        ),
        body: Column(
          children: <Widget>[
            const LinearProgressIndicator(value: 0.6, minHeight: 3, color: DesignTokens.gold, backgroundColor: DesignTokens.navyMid),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                _LangTab('عربي', true),
                SizedBox(width: 8),
                _LangTab('English', false),
                SizedBox(width: 8),
                _LangTab('قبطي', false),
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: <Widget>[
                  Center(child: Text('مزمور ٥٠', style: DesignTokens.ar(20, DesignTokens.gold))),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text('Ⲁⲣⲓⲡⲣⲟⲥⲉⲩⲭⲉ ⲉⲃⲟⲗ',
                        style: TextStyle(fontFamily: 'NotoSansCoptic', color: DesignTokens.copticRed, fontSize: 18)),
                  ),
                  const SizedBox(height: 12),
                  Text('ارحمني يا الله كعظيم رحمتك، ومثل كثرة رأفتك تمحو إثمي.',
                      style: DesignTokens.ar(20, DesignTokens.cream, FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text('Have mercy upon me, O God, according to Your loving kindness.',
                      style: DesignTokens.ui(16, DesignTokens.goldSoft)),
                  const SizedBox(height: 16),
                  const Divider(color: DesignTokens.gold),
                  const SizedBox(height: 8),
                  Center(child: Text('✝ رب ارحم ✝', style: DesignTokens.ar(18, DesignTokens.gold))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: DesignTokens.navyMid, boxShadow: <BoxShadow>[DesignTokens.shadow(0.15)]),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(color: DesignTokens.gold, shape: BoxShape.circle),
                        child: const Icon(Icons.play_arrow),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: 0.35,
                          color: DesignTokens.gold,
                          backgroundColor: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('١×', style: DesignTokens.ar(14, Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FloatingActionButton.extended(
                      onPressed: () {},
                      backgroundColor: DesignTokens.gold,
                      label: Text('أتممت الصلاة ✓', style: DesignTokens.ar(15, Colors.white)),
                    ),
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

class _LangTab extends StatelessWidget {
  const _LangTab(this.text, this.selected);
  final String text;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? DesignTokens.gold : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: DesignTokens.gold),
      ),
      child: Text(text, style: DesignTokens.ar(13, Colors.white)),
    );
  }
}
