import 'package:agpeya/presentation/locale/locale_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('LocaleCubit persists locale changes', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final cubit = LocaleCubit(prefs);

    expect(cubit.state.locale.languageCode, 'ar');

    await cubit.setEnglish();
    expect(cubit.state.locale.languageCode, 'en');
    expect(prefs.getString('locale'), 'en');

    await cubit.close();
  });
}
