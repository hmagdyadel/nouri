import 'package:agpeya/core/theme/app_colors.dart';
import 'package:agpeya/data/models/agpeya_model.dart';
import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/presentation/agpeya/viewmodel/agpeya_cubit.dart';
import 'package:agpeya/presentation/agpeya/viewmodel/agpeya_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PrayerReaderScreen extends StatefulWidget {
  const PrayerReaderScreen({
    required this.hourName,
    required this.hour,
    this.cubit,
    super.key,
  });
  final String hourName;
  final int hour;
  final AgpeyaCubit? cubit;

  @override
  State<PrayerReaderScreen> createState() => _PrayerReaderScreenState();
}

class _PrayerReaderScreenState extends State<PrayerReaderScreen> {
  bool completing = false;
  bool showSuccess = false;
  int selectedTab = 0;
  final List<String> _langs = <String>['ar', 'en', 'cop'];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> tabs = <String>[l10n.tab_arabic, l10n.tab_english, l10n.tab_coptic];
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
                    onPressed: () {},
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
                  onTap: () {
                    setState(() => selectedTab = index);
                    widget.cubit?.switchLanguage(_langs[index], _mapHourToId(widget.hour));
                  },
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
              child: widget.cubit == null
                  ? const Center(
                      child: Text(
                        'المحتوى المحلي متاح من شاشة الأجبية',
                        style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                      ),
                    )
                  : BlocBuilder<AgpeyaCubit, AgpeyaState>(
                      bloc: widget.cubit,
                      builder: (BuildContext context, AgpeyaState state) {
                        if (state is AgpeyaReaderLoading) {
                          return const Center(child: CircularProgressIndicator(color: AppColors.primaryGoldDark));
                        }
                        if (state is AgpeyaReaderError) {
                          return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
                        }
                        if (state is! AgpeyaReaderLoaded) {
                          return const SizedBox.shrink();
                        }
                        return SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                          child: Column(
                            children: <Widget>[
                              if (state.fallbackUsed)
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.orange.withValues(alpha: 0.9),
                                  child: const Text(
                                    'النص غير متاح بهذه اللغة — يتم عرض العربية',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white, fontFamily: 'Cairo'),
                                  ),
                                ),
                              _buildSections(state.hour, state.currentLang),
                              const SizedBox(height: 120),
                            ],
                          ),
                        );
                      },
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
                    child: const Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        LinearProgressIndicator(value: .2, color: AppColors.primaryGoldDark, minHeight: 4),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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

  Widget _buildSections(AgpeyaHourModel hour, String lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if ((hour.introduction ?? '').isNotEmpty)
          Text(
            hour.introduction!,
            textAlign: _align(lang),
            style: _style(lang).copyWith(fontStyle: FontStyle.italic, color: AppColors.textMuted),
          ),
        const SizedBox(height: 12),
        ..._paragraphs(hour.opening?.content ?? const <String>[], lang),
        if (hour.thanksgiving != null) ...<Widget>[
          _header(hour.thanksgiving!.title),
          ..._paragraphs(hour.thanksgiving!.content, lang),
        ],
        if (hour.introductoryPsalm != null) ...<Widget>[
          _header(hour.introductoryPsalm!.title),
          ..._verses(hour.introductoryPsalm!.verses, lang),
        ],
        if ((hour.psalmsIntro ?? '').isNotEmpty)
          Text(
            hour.psalmsIntro!,
            textAlign: _align(lang),
            style: _style(lang).copyWith(fontStyle: FontStyle.italic, color: AppColors.textMuted),
          ),
        if (hour.psalms != null)
          ...hour.psalms!.expand((AgpeyaPsalmModel p) => <Widget>[
                _header(p.title),
                ..._verses(p.verses, lang),
              ]),
        if (hour.gospel != null) ...<Widget>[
          _header(hour.gospel!.reference),
          if ((hour.gospel!.rubric ?? '').isNotEmpty)
            Text(hour.gospel!.rubric!, style: _style(lang).copyWith(fontStyle: FontStyle.italic, color: AppColors.textMuted)),
          ..._verses(hour.gospel!.verses, lang),
        ],
        if (hour.litanies != null) ...<Widget>[
          _header(hour.litanies!.title),
          ...hour.litanies!.content.map((String e) => Column(
                children: <Widget>[
                  Text(e, textAlign: _align(lang), style: _style(lang)),
                  const SizedBox(height: 6),
                  _kyrie(lang),
                ],
              )),
        ],
        if (hour.lordsPrayer != null) ...<Widget>[
          _header(hour.lordsPrayer!.title ?? 'الصلاة الربانية'),
          ..._paragraphs(hour.lordsPrayer!.content, lang),
        ],
        if (hour.closing != null) ...<Widget>[
          _header(hour.closing!.title),
          ..._paragraphs(hour.closing!.content, lang),
        ],
      ],
    );
  }

  List<Widget> _paragraphs(List<String> lines, String lang) =>
      lines.map((String e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(e, textAlign: _align(lang), style: _style(lang)),
          )).toList();

  List<Widget> _verses(List<AgpeyaVerseModel> verses, String lang) => verses
      .map(
        (AgpeyaVerseModel v) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 24,
                child: Text('${v.num}', style: const TextStyle(color: AppColors.primaryGoldDark, fontSize: 11)),
              ),
              Expanded(child: Text(v.text, style: _style(lang), textAlign: _align(lang))),
            ],
          ),
        ),
      )
      .toList();

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: <Widget>[
          Expanded(child: Divider(color: AppColors.primaryGoldDark.withValues(alpha: .3))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.primaryGoldDark,
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Divider(color: AppColors.primaryGoldDark.withValues(alpha: .3))),
        ],
      ),
    );
  }

  Widget _kyrie(String lang) {
    final String t = switch (lang) {
      'en' => 'Kyrie Eleison',
      'cop' => 'Ⲕⲩⲣⲓⲉ ⲉⲗⲉⲏⲥⲟⲛ',
      _ => 'يا رب ارحم',
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(Icons.add, color: AppColors.primaryGoldDark, size: 14),
        const SizedBox(width: 8),
        Text(
          t,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGoldDark,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.add, color: AppColors.primaryGoldDark, size: 14),
      ],
    );
  }

  TextStyle _style(String lang) {
    switch (lang) {
      case 'en':
        return const TextStyle(fontFamily: 'PlayfairDisplay', fontSize: 17, color: AppColors.backgroundIvory, height: 1.8);
      case 'cop':
        return const TextStyle(fontFamily: 'NotoSansCoptic', fontSize: 17, color: AppColors.copticRed, height: 2.2);
      default:
        return const TextStyle(fontFamily: 'Cairo', fontSize: 19, color: AppColors.backgroundIvory, height: 2.0);
    }
  }

  TextAlign _align(String lang) => lang == 'cop' ? TextAlign.center : (lang == 'ar' ? TextAlign.right : TextAlign.left);

  String _mapHourToId(int hour) {
    switch (hour) {
      case 1:
        return 'prime';
      case 3:
        return 'terce';
      case 6:
        return 'sext';
      case 9:
        return 'none';
      case 11:
        return 'vespers';
      case 12:
        return 'compline';
      default:
        return 'midnight';
    }
  }
}
