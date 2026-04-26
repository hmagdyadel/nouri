import 'package:agpeya/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Base widget tree renders', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await getIt.reset();
    await configureDependencies();
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('nouri-test')),
        ),
      ),
    );
    expect(find.text('nouri-test'), findsOneWidget);
  });
}
