import 'package:agpeya/design_preview/design_tokens.dart';
import 'package:flutter/material.dart';

class AgpeyaDesign extends StatelessWidget {
  const AgpeyaDesign({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> hours = <Map<String, dynamic>>[
      {'ar': 'صلاة باكر', 'en': 'Prime', 'cop': 'Ⲡⲣⲓⲙⲉ', 'time': '٦ ص', 'color': const Color(0xFFDAA520)},
      {'ar': 'الساعة الثالثة', 'en': 'Terce', 'cop': 'Ⲧⲉⲣⲥⲉ', 'time': '٩ ص', 'color': const Color(0xFFFFA726)},
      {'ar': 'الساعة السادسة', 'en': 'Sext', 'cop': 'Ⲥⲉⲝⲧ', 'time': '١٢ ظ', 'color': const Color(0xFFFBC02D)},
      {'ar': 'الساعة التاسعة', 'en': 'None', 'cop': 'Ⲛⲟⲛⲉ', 'time': '٣ م', 'color': const Color(0xFFFF8F00)},
      {'ar': 'الغروب', 'en': 'Vespers', 'cop': 'Ⲃⲉⲥⲡⲉⲣⲥ', 'time': '٦ م', 'color': const Color(0xFFB71C1C)},
      {'ar': 'النوم', 'en': 'Compline', 'cop': 'Ⲕⲟⲙⲡⲗⲓⲛⲉ', 'time': '٩ م', 'color': const Color(0xFF1E3A5F)},
      {'ar': 'نصف الليل', 'en': 'Midnight', 'cop': 'Ⲙⲓⲇⲛⲓⲅⲏⲧ', 'time': '١٢ ص', 'color': const Color(0xFF0D1B2A)},
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: DesignTokens.ivory,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 160,
              pinned: true,
              title: Text('الأجبية', style: DesignTokens.ar(20)),
              actions: const <Widget>[Padding(padding: EdgeInsets.all(12), child: Icon(Icons.add))],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  margin: const EdgeInsets.fromLTRB(16, 60, 16, 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: DesignTokens.goldLight),
                    gradient: const LinearGradient(colors: <Color>[Colors.white, DesignTokens.cream]),
                  ),
                  child: Center(child: Text('سبع مرات في النهار سبحتك', style: DesignTokens.ar(16))),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final item = hours[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: <BoxShadow>[DesignTokens.shadow(0.1)],
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(width: 6, height: 84, decoration: BoxDecoration(color: item['color'], borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)))),
                        const SizedBox(width: 10),
                        const CircleAvatar(child: Icon(Icons.wb_sunny_outlined)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(item['ar'], style: DesignTokens.ar(16)),
                              Text(item['en'], style: DesignTokens.ui(12, Colors.grey.shade700)),
                              Text(item['cop'], style: const TextStyle(fontFamily: 'NotoSansCoptic', color: DesignTokens.copticRed)),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: DesignTokens.gold, borderRadius: BorderRadius.circular(100)),
                              child: Text(item['time'], style: DesignTokens.ar(12, Colors.white)),
                            ),
                            const SizedBox(height: 6),
                            Text('١٥ دقيقة', style: DesignTokens.ui(11, DesignTokens.sage)),
                          ],
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  );
                },
                childCount: hours.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
