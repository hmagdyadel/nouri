import 'package:agpeya/core/logger/app_logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseRemoteSource {
  FirebaseRemoteSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String? get currentUid => _auth.currentUser?.uid;

  Future<List<int>> getTodayCompletedHours(String dateKey) async {
    final String? uid = currentUid;
    AppLogger.firebase('Fetching today completed hours', data: <String, dynamic>{'uid': uid, 'dateKey': dateKey});
    if (uid == null) return <int>[];
    final doc = await _firestore.collection('prayerLogs').doc(uid).collection('logs').doc(dateKey).get();
    final data = doc.data();
    if (data == null) return <int>[];
    final List<dynamic> raw = (data['hoursCompleted'] as List<dynamic>? ?? <dynamic>[]);
    final result = raw.map((dynamic e) => e as int).toList();
    AppLogger.firebase('Today completed hours fetched', data: <String, dynamic>{'result': result});
    return result;
  }

  Future<void> upsertCurrentUser({required String name, required String email}) async {
    final String? uid = currentUid;
    AppLogger.firebase('Upserting current user', data: <String, dynamic>{'uid': uid, 'name': name, 'email': email});
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).set(
      <String, dynamic>{
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<void> saveFcmToken() async {
    final String? uid = currentUid;
    if (uid == null) return;
    AppLogger.firebase('Saving FCM token', data: <String, dynamic>{'uid': uid});
    final String? token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) {
      AppLogger.warning('FCM token is empty');
      return;
    }
    await _firestore.collection('users').doc(uid).set(
      <String, dynamic>{'fcmToken': token},
      SetOptions(merge: true),
    );
    AppLogger.firebase('FCM token saved');
  }

  Future<void> saveNotificationSettings({
    required bool enabled,
    required List<String> hourTimes,
  }) async {
    final String? uid = currentUid;
    AppLogger.firebase('Saving notification settings', data: <String, dynamic>{'uid': uid, 'enabled': enabled});
    if (uid == null) return;
    await _firestore.collection('users').doc(uid).set(
      <String, dynamic>{
        'notificationsEnabled': enabled,
        'prayerReminderTimes': hourTimes,
      },
      SetOptions(merge: true),
    );
  }

  Future<bool> isUsernameAvailable(String username) async {
    AppLogger.firebase('Checking username availability', data: <String, dynamic>{'username': username});
    final doc = await _firestore.collection('usernames').doc(username).get();
    final available = !doc.exists;
    AppLogger.firebase('Username availability result', data: <String, dynamic>{'available': available});
    return available;
  }

  Future<void> saveProfile({
    required String displayName,
    required String username,
    required String church,
    required String city,
  }) async {
    final String? uid = currentUid;
    AppLogger.firebase('Saving user profile', data: <String, dynamic>{'uid': uid, 'username': username});
    if (uid == null) return;
    final String normalized = username.toLowerCase();
    await _firestore.collection('users').doc(uid).set(
      <String, dynamic>{
        'name': displayName,
        'username': normalized,
        'churchName': church,
        'city': city,
      },
      SetOptions(merge: true),
    );
    if (normalized.isNotEmpty) {
      await _firestore.collection('usernames').doc(normalized).set(
        <String, dynamic>{'uid': uid},
        SetOptions(merge: true),
      );
    }
    AppLogger.firebase('User profile saved successfully');
  }

  Future<Map<String, dynamic>> getCurrentProfile() async {
    final String? uid = currentUid;
    AppLogger.firebase('Fetching current profile', data: <String, dynamic>{'uid': uid});
    if (uid == null) return <String, dynamic>{};
    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data() ?? <String, dynamic>{};
    AppLogger.firebase('Current profile fetched', data: data);
    return data;
  }

  Future<Map<String, dynamic>> getUserStats(String uid) async {
    AppLogger.firebase('Fetching user stats', data: <String, dynamic>{'uid': uid});
    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data();
    if (data == null) return <String, dynamic>{'streak': 0, 'rank': 0, 'points': 0};
    
    return <String, dynamic>{
      'streak': data['streak'] ?? 0,
      'rank': data['rank'] ?? 0,
      'points': data['points'] ?? 0,
    };
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    AppLogger.firebase('Fetching leaderboard');
    final query = await _firestore
        .collection('users')
        .orderBy('points', descending: true)
        .limit(20)
        .get();
    
    final result = query.docs.map((doc) => {...doc.data(), 'uid': doc.id}).toList();
    AppLogger.firebase('Leaderboard fetched', data: <String, dynamic>{'count': result.length});
    return result;
  }
}
