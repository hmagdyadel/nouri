import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._preferences) : super(const LocaleState(Locale('ar'))) {
    _load();
  }

  final SharedPreferences _preferences;
  static const String _key = 'locale';

  void _load() {
    final String code = _preferences.getString(_key) ?? 'ar';
    emit(LocaleState(Locale(code)));
  }

  Future<void> setArabic() async {
    await _preferences.setString(_key, 'ar');
    emit(const LocaleState(Locale('ar')));
  }

  Future<void> setEnglish() async {
    await _preferences.setString(_key, 'en');
    emit(const LocaleState(Locale('en')));
  }
}
