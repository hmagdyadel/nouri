import 'package:agpeya/core/utils/coptic_calendar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Coptic calendar conversion returns valid month/day ranges', () {
    final date = CopticCalendar.fromGregorian(DateTime(2026, 4, 26));
    expect(date.day, inInclusiveRange(1, 30));
    expect(date.month, inInclusiveRange(1, 13));
  });
}
