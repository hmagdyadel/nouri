import 'package:agpeya/core/di/injection.dart';
import 'package:agpeya/core/firebase/firebase_service.dart';
import 'package:agpeya/core/router/app_router.dart';
import 'package:agpeya/core/storage/hive_service.dart';
import 'package:agpeya/core/theme/app_theme.dart';
import 'package:agpeya/data/models/prayer_log_model.dart';
import 'package:agpeya/data/models/settings_model.dart';
import 'package:agpeya/data/models/user_model.dart';
import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/presentation/locale/locale_cubit.dart';
import 'package:agpeya/presentation/locale/locale_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:agpeya/presentation/debug/debug_panel.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  await FirebaseService.initialize();
  await configureDependencies();
  if (!Hive.isAdapterRegistered(100)) Hive.registerAdapter(SettingsModelAdapter());
  if (!Hive.isAdapterRegistered(101)) Hive.registerAdapter(UserModelAdapter());
  if (!Hive.isAdapterRegistered(102)) Hive.registerAdapter(PrayerLogModelAdapter());
  runApp(const AgpeyaApp());
}

class AgpeyaApp extends StatelessWidget {
  const AgpeyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleCubit>(
      create: (_) => LocaleCubit(getIt<SharedPreferences>()),
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (BuildContext context, LocaleState state) {
          final Locale locale = state.locale;
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Nouri',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            locale: locale,
            supportedLocales: const <Locale>[Locale('ar'), Locale('en')],
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (BuildContext context, Widget? child) {
              return Directionality(
                textDirection: locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
                child: Stack(
                  children: <Widget>[
                    child ?? const SizedBox.shrink(),
                    if (kDebugMode)
                      Positioned(
                        bottom: 120,
                        left: 16,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const DebugPanel(),
                            );
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.red, width: 2),
                            ),
                            child: const Icon(Icons.bug_report, color: Colors.red, size: 24),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
            routerConfig: AppRouter.createRouter(),
          );
        },
      ),
    );
  }
}
