import 'package:agpeya/core/constants/prayer_data.dart';
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
  final String content;

  @override
  State<PrayerReaderScreen> createState() => _PrayerReaderScreenState();
}

class _PrayerReaderScreenState extends State<PrayerReaderScreen> {
  double fontSize = 20;
  bool completing = false;
  bool showSuccess = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.hourName)),
        body: Column(
          children: <Widget>[
            LinearProgressIndicator(value: 0.2, color: Theme.of(context).colorScheme.primary),
            TabBar(
              tabs: <Widget>[
                Tab(text: l10n.tab_arabic),
                Tab(text: l10n.tab_english),
                Tab(text: l10n.tab_coptic),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Text(widget.content.isEmpty ? firstHourFallbackArabic : widget.content, style: TextStyle(fontSize: fontSize)),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Text(l10n.prime_content_en, style: TextStyle(fontSize: fontSize)),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Text('Ⲡⲣⲟⲥⲉⲩⲭⲏ ⲛ̀ⲧⲉ ⲡⲣⲓⲙⲉ', style: TextStyle(fontSize: fontSize)),
                  ),
                ],
              ),
            ),
            Slider(
              value: fontSize,
              min: 16,
              max: 32,
              onChanged: (double v) => setState(() => fontSize = v),
            ),
            ListTile(
              leading: const Icon(Icons.play_circle_fill),
              title: Text(l10n.audio_player),
              subtitle: Text(l10n.audio_source_label),
            ),
            if (showSuccess)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  '+10 نقاط',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
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
                  icon: completing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle),
                  label: Text(completing ? '${l10n.save_btn}...' : l10n.mark_complete_btn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
