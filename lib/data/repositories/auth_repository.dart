import 'dart:io' show Platform;

import 'package:agpeya/core/error/failure.dart';
import 'package:agpeya/core/logger/app_logger.dart';
import 'package:agpeya/data/sources/local/prayer_local_source.dart';
import 'package:agpeya/data/sources/remote/firebase_remote_source.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  AuthRepository(
    this._auth,
    this._firebaseRemoteSource,
    this._prayerLocalSource,
    this._functions,
  );
  final FirebaseAuth _auth;
  final FirebaseRemoteSource _firebaseRemoteSource;
  final PrayerLocalSource _prayerLocalSource;
  final FirebaseFunctions _functions;

  Future<Either<Failure, UserCredential>> signInAnonymously() async {
    AppLogger.info('Sign in anonymously');
    try {
      final UserCredential credential = await _auth.signInAnonymously();
      AppLogger.success('Anonymous sign-in successful', data: <String, dynamic>{'uid': credential.user?.uid});
      await _firebaseRemoteSource.upsertCurrentUser(
        name: 'عبد المسيح',
        email: credential.user?.email ?? 'anonymous@agpeya.app',
      );
      await _firebaseRemoteSource.saveFcmToken();
      return Right<Failure, UserCredential>(credential);
    } catch (e, stack) {
      AppLogger.error('Anonymous sign-in failed', error: e, stack: stack);
      return Left<Failure, UserCredential>(ServerFailure('Auth failed: $e'));
    }
  }

  bool get isSignedIn => _auth.currentUser != null && !_auth.currentUser!.isAnonymous;

  Future<void> _migrateGuestLogsIfAny() async {
    AppLogger.info('Checking for guest logs to migrate');
    final List<String> keys =
        _prayerLocalSource.getKeys().where((String k) => k.startsWith('guest_logs_')).toList();
    if (keys.isEmpty) {
      AppLogger.info('No guest logs to migrate');
      return;
    }
    AppLogger.warning('Found guest logs to migrate', data: <String, dynamic>{'count': keys.length});
    final Map<String, dynamic> logs = <String, dynamic>{};
    for (final String key in keys) {
      logs[key.replaceFirst('guest_logs_', '')] = _prayerLocalSource.getPrayer(key) ?? '';
    }
    final HttpsCallable callable = _functions.httpsCallable('migrateGuestLogsCallable');
    await callable.call(<String, dynamic>{'logs': logs});
    for (final String key in keys) {
      await _prayerLocalSource.remove(key);
    }
    AppLogger.success('Guest logs migrated successfully');
  }

  Future<Either<Failure, UserCredential>> signInWithGoogle() async {
    AppLogger.info('Sign in with Google');
    try {
      if (!(Platform.isAndroid || Platform.isIOS || Platform.isMacOS)) {
        return Left<Failure, UserCredential>(
          const ServerFailure('Google sign-in is not enabled on this platform.'),
        );
      }
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        AppLogger.warning('Google sign-in cancelled by user');
        return Left<Failure, UserCredential>(ServerFailure('Google sign-in cancelled.'));
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential result = await _auth.signInWithCredential(credential);
      AppLogger.success('Google sign-in successful', data: <String, dynamic>{'uid': result.user?.uid});
      await _firebaseRemoteSource.upsertCurrentUser(
        name: result.user?.displayName ?? 'User',
        email: result.user?.email ?? 'user@agpeya.app',
      );
      await _firebaseRemoteSource.saveFcmToken();
      await _migrateGuestLogsIfAny();
      return Right<Failure, UserCredential>(result);
    } catch (e, stack) {
      AppLogger.error('Google sign-in failed', error: e, stack: stack);
      return Left<Failure, UserCredential>(ServerFailure('Google sign-in failed: $e'));
    }
  }

  Future<Either<Failure, UserCredential>> signInWithApple() async {
    AppLogger.info('Sign in with Apple');
    try {
      final bool available = await SignInWithApple.isAvailable();
      if (!available) {
        return Left<Failure, UserCredential>(
          const ServerFailure('Apple sign-in is not available on this device.'),
        );
      }
      final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthCredential oauthCredential = OAuthProvider('apple.com').credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );
      final UserCredential result = await _auth.signInWithCredential(oauthCredential);
      AppLogger.success('Apple sign-in successful', data: <String, dynamic>{'uid': result.user?.uid});
      await _firebaseRemoteSource.upsertCurrentUser(
        name: result.user?.displayName ?? 'Apple User',
        email: result.user?.email ?? 'apple@agpeya.app',
      );
      await _firebaseRemoteSource.saveFcmToken();
      await _migrateGuestLogsIfAny();
      return Right<Failure, UserCredential>(result);
    } catch (e, stack) {
      AppLogger.error('Apple sign-in failed', error: e, stack: stack);
      return Left<Failure, UserCredential>(ServerFailure('Apple sign-in failed: $e'));
    }
  }

  Future<Either<Failure, void>> signOut() async {
    AppLogger.info('Signing out');
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      AppLogger.success('Sign out successful');
      return const Right<Failure, void>(null);
    } catch (e, stack) {
      AppLogger.error('Sign out failed', error: e, stack: stack);
      return Left<Failure, void>(ServerFailure('Sign out failed: $e'));
    }
  }
}
