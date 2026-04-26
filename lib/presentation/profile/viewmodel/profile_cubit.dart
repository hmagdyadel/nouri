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
    emit(ProfileLoading());
    await _localNotificationsService.initialize();
    emit(const ProfileLoaded('عبد المسيح', 540, true));
  }

  Future<void> toggleNotifications(bool enabled) async {
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
    emit(ProfileLoaded(current.name, current.points, enabled));
  }
}
