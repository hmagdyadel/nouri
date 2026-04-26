import 'package:agpeya/core/network/api_service.dart';
import 'package:agpeya/core/network/dio_client.dart';
import 'package:agpeya/core/network/network_info.dart';
import 'package:agpeya/core/notifications/local_notifications_service.dart';
import 'package:agpeya/data/repositories/gospel_repository.dart';
import 'package:agpeya/data/repositories/leaderboard_repository.dart';
import 'package:agpeya/data/repositories/prayer_repository.dart';
import 'package:agpeya/data/repositories/auth_repository.dart';
import 'package:agpeya/data/sources/local/prayer_local_source.dart';
import 'package:agpeya/data/sources/remote/agpeya_api_source.dart';
import 'package:agpeya/data/sources/remote/firebase_remote_source.dart';
import 'package:agpeya/domain/usecases/get_daily_gospel_usecase.dart';
import 'package:agpeya/domain/usecases/get_leaderboard_usecase.dart';
import 'package:agpeya/domain/usecases/log_prayer_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!getIt.isRegistered<SharedPreferences>()) {
    getIt.registerSingleton<SharedPreferences>(prefs);
  }
  getIt.registerLazySingleton<Dio>(DioClient.create);
  getIt.registerLazySingleton<Connectivity>(Connectivity.new);
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfo(getIt()));
  getIt.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFunctions>(() => FirebaseFunctions.instance);
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
    FlutterLocalNotificationsPlugin.new,
  );

  getIt.registerLazySingleton<AgpeyaApiService>(() => AgpeyaApiService(getIt()));
  getIt.registerLazySingleton<AgpeyaApiSource>(() => AgpeyaApiSource(getIt()));
  getIt.registerLazySingleton<PrayerLocalSource>(() => PrayerLocalSource(getIt()));
  getIt.registerLazySingleton<FirebaseRemoteSource>(
    () => FirebaseRemoteSource(firestore: getIt(), auth: getIt()),
  );

  getIt.registerLazySingleton<PrayerRepository>(
    () => PrayerRepositoryImpl(
      apiSource: getIt(),
      localSource: getIt(),
      firebaseSource: getIt(),
      functions: getIt(),
    ),
  );
  getIt.registerLazySingleton<LeaderboardRepository>(LeaderboardRepository.new);
  getIt.registerLazySingleton<GospelRepository>(() => GospelRepository(getIt()));
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt(), getIt(), getIt(), getIt()),
  );
  getIt.registerLazySingleton<LocalNotificationsService>(
    () => LocalNotificationsService(getIt()),
  );

  getIt.registerLazySingleton<LogPrayerUseCase>(() => LogPrayerUseCase(getIt()));
  getIt.registerLazySingleton<GetLeaderboardUseCase>(() => GetLeaderboardUseCase(getIt()));
  getIt.registerLazySingleton<GetDailyGospelUseCase>(() => GetDailyGospelUseCase(getIt()));
}
