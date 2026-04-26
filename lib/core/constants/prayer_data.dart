class PrayerHourData {
  const PrayerHourData({
    required this.hour,
    required this.arabicName,
    required this.englishName,
    required this.copticName,
    required this.timeText,
    required this.theme,
    required this.duration,
  });

  final int hour;
  final String arabicName;
  final String englishName;
  final String copticName;
  final String timeText;
  final String theme;
  final String duration;
}

const List<PrayerHourData> agpeyaHours = <PrayerHourData>[
  PrayerHourData(hour: 1, arabicName: 'صلاة بكرة', englishName: 'Prime', copticName: 'Ⲡⲣⲓⲙⲉ', timeText: '٦ صباحاً', theme: 'Incarnation & Resurrection', duration: '١٥ دقيقة'),
  PrayerHourData(hour: 3, arabicName: 'الساعة الثالثة', englishName: 'Terce', copticName: 'Ⲧⲉⲣⲥⲉ', timeText: '٩ صباحاً', theme: 'Holy Spirit descent', duration: '١٥ دقيقة'),
  PrayerHourData(hour: 6, arabicName: 'الساعة السادسة', englishName: 'Sext', copticName: 'Ⲥⲉⲝⲧ', timeText: '١٢ ظهراً', theme: 'Crucifixion', duration: '١٥ دقيقة'),
  PrayerHourData(hour: 9, arabicName: 'الساعة التاسعة', englishName: 'None', copticName: 'Ⲛⲟⲛⲉ', timeText: '٣ عصراً', theme: 'Death of Christ', duration: '١٥ دقيقة'),
  PrayerHourData(hour: 11, arabicName: 'الغروب', englishName: 'Vespers', copticName: 'Ⲃⲉⲥⲡⲉⲣⲥ', timeText: '٦ مساءً', theme: 'Removal from the Cross', duration: '١٥ دقيقة'),
  PrayerHourData(hour: 12, arabicName: 'النوم', englishName: 'Compline', copticName: 'Ⲕⲟⲙⲡⲗⲓⲛⲉ', timeText: '٩ مساءً', theme: 'Burial of Christ', duration: '١٥ دقيقة'),
  PrayerHourData(hour: 0, arabicName: 'نصف الليل', englishName: 'Midnight', copticName: 'Ⲙⲓⲇⲛⲓⲅⲏⲧ', timeText: '١٢ صباحاً', theme: 'Second Coming', duration: '٢٠ دقيقة'),
];

const String firstHourFallbackArabic = '''
شكرا لك يا رب لأنك أقمتنا من النوم...
هذه صلاة باكر كنسخة احتياطية للعمل دون إنترنت.
''';
