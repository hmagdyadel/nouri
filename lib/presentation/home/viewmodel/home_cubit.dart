import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/core/di/injection.dart';
import 'package:agpeya/data/repositories/prayer_repository.dart';
import 'package:agpeya/core/utils/coptic_calendar.dart';
import 'package:agpeya/data/repositories/auth_repository.dart';
import 'package:agpeya/data/sources/remote/firebase_remote_source.dart';
import 'package:agpeya/data/repositories/gospel_repository.dart';
import 'package:agpeya/data/models/gospel_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/rendering.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    AuthRepository? authRepository,
    FirebaseRemoteSource? firebaseRemoteSource,
    PrayerRepository? prayerRepository,
    GospelRepository? gospelRepository,
  })  : _authRepository = authRepository ?? getIt<AuthRepository>(),
        _firebaseRemoteSource = firebaseRemoteSource ?? getIt<FirebaseRemoteSource>(),
        _prayerRepository = prayerRepository ?? getIt<PrayerRepository>(),
        _gospelRepository = gospelRepository ?? getIt<GospelRepository>(),
        super(HomeInitial());

  final GlobalKey cardKey = GlobalKey();
  final AuthRepository _authRepository;
  final FirebaseRemoteSource _firebaseRemoteSource;
  final PrayerRepository _prayerRepository;
  final GospelRepository _gospelRepository;

  Future<void> load() async {
    AppLogger.cubit('HomeCubit', 'HomeLoading');
    emit(HomeLoading());
    final DateTime now = DateTime.now();
    final int hour = now.hour;
    final String greeting = hour < 12 ? 'صباح الخير' : (hour < 18 ? 'طاب يومك' : 'مساء الخير');
    final CopticDate coptic = CopticCalendar.fromGregorian(now);
    final String copticDate = '${coptic.day} / ${coptic.month} / ${coptic.year}';
    
    final bool isGuest = !_authRepository.isSignedIn;
    final String? uid = _firebaseRemoteSource.currentUid;
    
    final Map<String, dynamic> profile =
        isGuest ? <String, dynamic>{} : await _firebaseRemoteSource.getCurrentProfile();
        
    final List<int> progress =
        (await _prayerRepository.getCompletedHoursToday()).fold((_) => <int>[], (r) => r);
    
    final gospelResult = await _gospelRepository.getDailyGospel();
    final GospelModel gospel = gospelResult.fold(
      (_) => const GospelModel(arabic: 'صلوا بلا انقطاع', english: 'Pray without ceasing.', coptic: 'Ⲁⲣⲓⲡⲣⲟⲥⲉⲩⲭⲉ ⲉⲃⲟⲗ'),
      (g) => g,
    );

    Map<String, dynamic> statsData = <String, dynamic>{'streak': 0, 'rank': 0, 'points': 0};
    if (uid != null) {
      statsData = await _firebaseRemoteSource.getUserStats(uid);
    }

    final state = HomeLoaded(
      greeting: greeting,
      copticDate: copticDate,
      displayName: profile['name'] as String?,
      username: profile['username'] as String?,
      isGuest: isGuest,
      cardArabic: gospel.arabic,
      cardEnglish: gospel.english,
      cardCoptic: gospel.coptic,
      progressHours: progress,
      stats: HomeStats(
        streak: statsData['streak'] as int? ?? 0,
        rank: statsData['rank'] as int? ?? 0,
        pointsToday: statsData['points'] as int? ?? 0,
      ),
    );
    
    AppLogger.cubit('HomeCubit', 'HomeLoaded', data: <String, dynamic>{
      'isGuest': isGuest,
      'points': statsData['points'],
      'gospelRef': gospel.reference,
    });
    emit(state);
  }

  Future<Uint8List?> captureCard() async {
    AppLogger.info('Capturing home card image');
    final BuildContext? context = cardKey.currentContext;
    if (context == null) return null;
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) return null;
    final ui.Image image = await renderObject.toImage(pixelRatio: 2.5);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<List<String>> openPrayerContent(int hour) async {
    AppLogger.info('Opening prayer content from home', data: <String, dynamic>{'hour': hour});
    final result = await _prayerRepository.getPrayerHourContent(hour);
    return result.fold(
      (f) {
        AppLogger.error('Failed to open prayer content', error: f.message);
        return <String>['', '', ''];
      },
      (content) => content,
    );
  }
}
