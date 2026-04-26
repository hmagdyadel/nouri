import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:agpeya/core/di/injection.dart';
import 'package:agpeya/core/utils/coptic_calendar.dart';
import 'package:agpeya/data/repositories/auth_repository.dart';
import 'package:agpeya/data/sources/remote/firebase_remote_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/rendering.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    AuthRepository? authRepository,
    FirebaseRemoteSource? firebaseRemoteSource,
  })  : _authRepository = authRepository ?? getIt<AuthRepository>(),
        _firebaseRemoteSource = firebaseRemoteSource ?? getIt<FirebaseRemoteSource>(),
        super(HomeInitial());

  final GlobalKey cardKey = GlobalKey();
  final AuthRepository _authRepository;
  final FirebaseRemoteSource _firebaseRemoteSource;

  Future<void> load() async {
    emit(HomeLoading());
    final DateTime now = DateTime.now();
    final int hour = now.hour;
    final String greeting = hour < 12 ? 'morning' : (hour < 18 ? 'afternoon' : 'evening');
    final CopticDate coptic = CopticCalendar.fromGregorian(now);
    final String copticDate = '${coptic.day}/${coptic.month}/${coptic.year}';
    final bool isGuest = !_authRepository.isSignedIn;
    final Map<String, dynamic> profile =
        isGuest ? <String, dynamic>{} : await _firebaseRemoteSource.getCurrentProfile();
    emit(
      HomeLoaded(
        greeting: greeting,
        copticDate: copticDate,
        displayName: profile['name'] as String?,
        username: profile['username'] as String?,
        isGuest: isGuest,
        cardArabic: 'صلوا بلا انقطاع',
        cardEnglish: 'Pray without ceasing.',
        cardCoptic: 'Ⲁⲣⲓⲡⲣⲟⲥⲉⲩⲭⲉ ⲉⲃⲟⲗ',
        progressHours: <int>[1, 3],
        stats: HomeStats(streak: 4, rank: 12, pointsToday: 28),
      ),
    );
  }

  Future<Uint8List?> captureCard() async {
    final BuildContext? context = cardKey.currentContext;
    if (context == null) return null;
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) return null;
    final ui.Image image = await renderObject.toImage(pixelRatio: 2.5);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}
