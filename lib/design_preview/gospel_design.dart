import 'package:agpeya/design_preview/design_tokens.dart';
import 'package:flutter/material.dart';

class GospelDesign extends StatelessWidget {
  const GospelDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: DesignTokens.ivory,
        appBar: AppBar(title: Text('الإنجيل', style: DesignTokens.ar(22))),
        body: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(colors: <Color>[DesignTokens.copticRed, DesignTokens.navy]),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('إنجيل اليوم', style: DesignTokens.ar(22, Colors.white)),
                  Text('١٧ بشنس ١٧٤٠ - 26 May', style: DesignTokens.ui(12, DesignTokens.goldSoft)),
                  Text('إنجيل يوحنا ١٠: ١-١٦', style: DesignTokens.ar(14, Colors.white)),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                _Tab('عربي', true),
                SizedBox(width: 8),
                _Tab('English', false),
                SizedBox(width: 8),
                _Tab('قبطي', false),
              ],
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 8,
                itemBuilder: (_, int i) {
                  final bool highlighted = i == 2;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: highlighted ? DesignTokens.goldSoft.withValues(alpha: 0.5) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(radius: 12, backgroundColor: DesignTokens.gold, child: Text('${i + 1}', style: DesignTokens.ui(10, Colors.white))),
                        const SizedBox(width: 10),
                        Expanded(child: Text('أنا هو الراعي الصالح، والراعي الصالح يبذل نفسه عن الخراف.', style: DesignTokens.ar(15))),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(backgroundColor: DesignTokens.gold),
                      child: Text('قرأت الإنجيل اليوم', style: DesignTokens.ar(15, Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(onPressed: () {}, icon: const Icon(Icons.share), style: IconButton.styleFrom(backgroundColor: DesignTokens.navyMid)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab(this.text, this.selected);
  final String text;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? DesignTokens.gold : Colors.transparent,
        border: Border.all(color: DesignTokens.gold),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(text, style: DesignTokens.ar(13, selected ? Colors.white : DesignTokens.gold)),
    );
  }
}
