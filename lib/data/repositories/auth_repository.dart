import 'package:agpeya/core/error/failure.dart';
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
    try {
      final UserCredential credential = await _auth.signInAnonymously();
      await _firebaseRemoteSource.upsertCurrentUser(
        name: 'عبد المسيح',
        email: credential.user?.email ?? 'anonymous@agpeya.app',
      );
      await _firebaseRemoteSource.saveFcmToken();
      return Right<Failure, UserCredential>(credential);
    } catch (e) {
      return Left<Failure, UserCredential>(ServerFailure('Auth failed: $e'));
    }
  }

  bool get isSignedIn => _auth.currentUser != null && !_auth.currentUser!.isAnonymous;

  Future<void> _migrateGuestLogsIfAny() async {
    final List<String> keys =
        _prayerLocalSource.getKeys().where((String k) => k.startsWith('guest_logs_')).toList();
    if (keys.isEmpty) return;
    final Map<String, dynamic> logs = <String, dynamic>{};
    for (final String key in keys) {
      logs[key.replaceFirst('guest_logs_', '')] = _prayerLocalSource.getPrayer(key) ?? '';
    }
    final HttpsCallable callable = _functions.httpsCallable('migrateGuestLogsCallable');
    await callable.call(<String, dynamic>{'logs': logs});
    for (final String key in keys) {
      await _prayerLocalSource.remove(key);
    }
  }

  Future<Either<Failure, UserCredential>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return Left<Failure, UserCredential>(ServerFailure('Google sign-in cancelled.'));
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential result = await _auth.signInWithCredential(credential);
      await _firebaseRemoteSource.upsertCurrentUser(
        name: result.user?.displayName ?? 'User',
        email: result.user?.email ?? 'user@agpeya.app',
      );
      await _firebaseRemoteSource.saveFcmToken();
      await _migrateGuestLogsIfAny();
      return Right<Failure, UserCredential>(result);
    } catch (e) {
      return Left<Failure, UserCredential>(ServerFailure('Google sign-in failed: $e'));
    }
  }

  Future<Either<Failure, UserCredential>> signInWithApple() async {
    try {
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
      await _firebaseRemoteSource.upsertCurrentUser(
        name: result.user?.displayName ?? 'Apple User',
        email: result.user?.email ?? 'apple@agpeya.app',
      );
      await _firebaseRemoteSource.saveFcmToken();
      await _migrateGuestLogsIfAny();
      return Right<Failure, UserCredential>(result);
    } catch (e) {
      return Left<Failure, UserCredential>(ServerFailure('Apple sign-in failed: $e'));
    }
  }

  Future<Either<Failure, void>> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      return const Right<Failure, void>(null);
    } catch (e) {
      return Left<Failure, void>(ServerFailure('Sign out failed: $e'));
    }
  }
}
