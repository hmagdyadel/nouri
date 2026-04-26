class CopticDate {
  CopticDate(this.day, this.month, this.year);
  final int day;
  final int month;
  final int year;

  @override
  String toString() => '$day/$month/$year';
}

class CopticCalendar {
  static CopticDate fromGregorian(DateTime date) {
    final DateTime copticNewYear = DateTime(date.year, 9, 11);
    DateTime base = copticNewYear;
    int copticYear = date.year - 284;
    if (date.isBefore(copticNewYear)) {
      base = DateTime(date.year - 1, 9, 11);
      copticYear -= 1;
    }

    final int days = date.difference(base).inDays;
    final int month = (days ~/ 30) + 1;
    final int day = (days % 30) + 1;
    return CopticDate(day, month, copticYear);
  }
}
