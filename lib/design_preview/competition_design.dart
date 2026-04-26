import 'package:agpeya/design_preview/design_tokens.dart';
import 'package:flutter/material.dart';

class CompetitionDesign extends StatelessWidget {
  const CompetitionDesign({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> users = <Map<String, String>>[
      {'name': 'مينا جرجس', 'church': 'كنيسة مارجرجس — الإسكندرية', 'points': '1230'},
      {'name': 'مريم فارس', 'church': 'كنيسة العذراء — القاهرة', 'points': '1100'},
      {'name': 'بطرس ميخائيل', 'church': 'كنيسة مارمرقس — أسيوط', 'points': '980'},
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: DesignTokens.ivory,
        appBar: AppBar(title: Text('المنافسة', style: DesignTokens.ar(22))),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: DesignTokens.gold, borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.access_time, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('يتجدد خلال ٢ي ١٤س ٣٣د', style: DesignTokens.ar(14, Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(children: const <Widget>[_Pill('أسبوعي', true), SizedBox(width: 8), _Pill('شهري', false), SizedBox(width: 8), _Pill('كل الوقت', false)]),
            const SizedBox(height: 12),
            Row(children: const <Widget>[_Pill('🌍 عالمي', true), SizedBox(width: 8), _Pill('🏛️ كنيستي', false), SizedBox(width: 8), _Pill('👨‍👩‍👧 عائلتي', false)]),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _podium('2', 'مريم', '1100', Colors.grey.shade400, 90),
                _podium('1', 'مينا', '1230', DesignTokens.gold, 120),
                _podium('3', 'بطرس', '980', const Color(0xFFB87333), 80),
              ],
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < users.length; i++)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: <BoxShadow>[DesignTokens.shadow(0.08)]),
                child: Row(
                  children: <Widget>[
                    Text('${i + 4}', style: DesignTokens.ui(24, Colors.grey.shade500, FontWeight.w700)),
                    const SizedBox(width: 10),
                    const CircleAvatar(child: Text('MJ')),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                        Text(users[i]['name']!, style: DesignTokens.ar(15)),
                        Text(users[i]['church']!, style: DesignTokens.ui(11, Colors.grey.shade700)),
                      ]),
                    ),
                    Text(users[i]['points']!, style: DesignTokens.ar(16, DesignTokens.gold, FontWeight.w700)),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(right: BorderSide(color: DesignTokens.gold, width: 4)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: <Widget>[
                  Text('١٨', style: DesignTokens.ar(20)),
                  const SizedBox(width: 10),
                  const CircleAvatar(child: Text('أنت')),
                  const SizedBox(width: 10),
                  Expanded(child: Text('أنت — مينا جرجس', style: DesignTokens.ar(14))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: DesignTokens.goldSoft, borderRadius: BorderRadius.circular(100)),
                    child: Text('أنت', style: DesignTokens.ar(12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _podium(String rank, String name, String points, Color color, double size) {
    return Column(
      children: <Widget>[
        Icon(Icons.workspace_premium, color: color),
        CircleAvatar(radius: size / 6, child: Text(name.characters.first)),
        const SizedBox(height: 4),
        Text('#$rank', style: DesignTokens.ar(16)),
        Text(points, style: DesignTokens.ui(12)),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.label, this.selected);
  final String label;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? DesignTokens.gold : Colors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: selected ? DesignTokens.gold : Colors.grey.shade400),
      ),
      child: Text(label, style: DesignTokens.ar(12, selected ? Colors.white : DesignTokens.navy)),
    );
  }
}
