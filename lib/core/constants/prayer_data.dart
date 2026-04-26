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

const Map<int, String> fallbackPrayerArabicByHour = <int, String>{
  1: 'صلاة باكر: نشكرك يا رب لأنك أقمتنا من نوم الليل، وأنرت عقولنا لنمجدك طوال النهار.',
  3: 'الساعة الثالثة: أيها الملك السمائي المعزي، روح الحق، تعال واسكن فينا.',
  6: 'الساعة السادسة: يا من صُلب في الساعة السادسة من أجل خلاصنا، أمِت أهواءنا.',
  9: 'الساعة التاسعة: يا من ذاق الموت بالجسد وقت الساعة التاسعة، أمت حواسنا الجسدية.',
  11: 'صلاة الغروب: ها قد انقضى النهار، فلتصعد صلاتنا أمامك يا رب.',
  12: 'صلاة النوم: أعطنا يا رب عند رقادنا نوما هادئا وأفكارا طاهرة.',
  0: 'صلاة نصف الليل: هوذا العريس يأتي في نصف الليل، طوبى للعبد الذي يجده مستيقظا.',
};

const Map<int, String> fallbackPrayerEnglishByHour = <int, String>{
  1: 'Prime: We thank You, O Lord, for raising us from sleep and granting us a day of praise.',
  3: 'Terce: O Heavenly King, the Comforter, Spirit of Truth, come and dwell in us.',
  6: 'Sext: You who were crucified at the sixth hour for our sake, put to death our passions.',
  9: 'None: You who tasted death in the ninth hour, mortify our earthly senses.',
  11: 'Vespers: The day has passed; let our evening prayer ascend before You.',
  12: 'Compline: Grant us peaceful sleep and pure thoughts through the night.',
  0: 'Midnight: Behold, the Bridegroom comes at midnight; blessed is the servant found vigilant.',
};

const Map<int, String> fallbackPrayerCopticByHour = <int, String>{
  1: 'Ⲡⲣⲓⲙⲉ ⲛ̀ⲧⲉ ⲡⲓⲉϩⲟⲟⲩ',
  3: 'Ⲧⲉⲣⲥⲉ ⲛ̀ⲧⲉ ⲡⲓⲉϩⲟⲟⲩ',
  6: 'Ⲥⲉⲝⲧ ⲛ̀ⲧⲉ ⲡⲓⲉϩⲟⲟⲩ',
  9: 'Ⲛⲟⲛⲉ ⲛ̀ⲧⲉ ⲡⲓⲉϩⲟⲟⲩ',
  11: 'Ⲃⲉⲥⲡⲉⲣⲥ',
  12: 'Ⲕⲟⲙⲡⲗⲓⲛⲉ',
  0: 'Ⲙⲓⲇⲛⲓⲅⲏⲧ',
};

const String fallbackGospelArabic =
    'في البدء كان الكلمة، والكلمة كان عند الله، وكان الكلمة الله. فيه كانت الحياة، والحياة كانت نور الناس.';

const String fallbackGospelEnglish =
    'In the beginning was the Word, and the Word was with God, and the Word was God. In Him was life.';

const String fallbackGospelCoptic = 'Ⲡⲓⲉⲩⲁⲅⲅⲉⲗⲓⲟⲛ ⲛ̀ⲧⲉ ⲡⲉϩⲟⲟⲩ';
