import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/core/di/injection.dart';
import 'package:agpeya/core/notifications/local_notifications_service.dart';
import 'package:agpeya/data/sources/remote/firebase_remote_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    FirebaseRemoteSource? firebaseRemoteSource,
    LocalNotificationsService? localNotificationsService,
  })  : _firebaseRemoteSource = firebaseRemoteSource ?? getIt<FirebaseRemoteSource>(),
        _localNotificationsService = localNotificationsService ?? getIt<LocalNotificationsService>(),
        super(ProfileInitial());

  final FirebaseRemoteSource _firebaseRemoteSource;
  final LocalNotificationsService _localNotificationsService;
  static const List<String> _defaultPrayerTimes = <String>[
    '06:00',
    '09:00',
    '12:00',
    '15:00',
    '18:00',
    '21:00',
    '00:00',
  ];

  Future<void> load() async {
    AppLogger.cubit('ProfileCubit', 'ProfileLoading');
    emit(ProfileLoading());
    await _localNotificationsService.initialize();
    
    final Map<String, dynamic> profile = await _firebaseRemoteSource.getCurrentProfile();
    final String? uid = _firebaseRemoteSource.currentUid;
    
    int points = 0;
    if (uid != null) {
      final stats = await _firebaseRemoteSource.getUserStats(uid);
      points = stats['points'] as int? ?? 0;
    }

    final String name = profile['name'] as String? ?? 'عبد المسيح';
    final bool notifications = profile['notificationsEnabled'] as bool? ?? true;

    AppLogger.cubit('ProfileCubit', 'ProfileLoaded');
    emit(ProfileLoaded(name, points, notifications));
  }

  Future<void> toggleNotifications(bool enabled) async {
    AppLogger.info('Toggling notifications', data: <String, dynamic>{'enabled': enabled});
    if (state is! ProfileLoaded) return;
    final ProfileLoaded current = state as ProfileLoaded;
    await _localNotificationsService.syncPrayerReminders(
      enabled: enabled,
      hourTimes: _defaultPrayerTimes,
    );
    await _firebaseRemoteSource.saveNotificationSettings(
      enabled: enabled,
      hourTimes: _defaultPrayerTimes,
    );
    await _firebaseRemoteSource.saveFcmToken();
    AppLogger.cubit('ProfileCubit', 'ProfileLoaded (Notification update)', data: <String, dynamic>{'enabled': enabled});
    emit(ProfileLoaded(current.name, current.points, enabled));
  }
}
