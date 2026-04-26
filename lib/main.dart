import 'package:agpeya/core/di/injection.dart';
import 'package:agpeya/core/firebase/firebase_service.dart';
import 'package:agpeya/core/router/app_router.dart';
import 'package:agpeya/core/theme/app_theme.dart';
import 'package:agpeya/l10n/app_localizations.dart';
import 'package:agpeya/presentation/locale/locale_cubit.dart';
import 'package:agpeya/presentation/locale/locale_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  await configureDependencies();
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
                child: child ?? const SizedBox.shrink(),
              );
            },
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
