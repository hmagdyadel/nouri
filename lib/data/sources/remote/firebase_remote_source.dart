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
    if (uid == null) return <int>[];
    final doc = await _firestore.collection('prayerLogs').doc(uid).collection('logs').doc(dateKey).get();
    final data = doc.data();
    if (data == null) return <int>[];
    final List<dynamic> raw = (data['hoursCompleted'] as List<dynamic>? ?? <dynamic>[]);
    return raw.map((dynamic e) => e as int).toList();
  }

  Future<void> upsertCurrentUser({required String name, required String email}) async {
    final String? uid = currentUid;
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
    final String? token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) return;
    await _firestore.collection('users').doc(uid).set(
      <String, dynamic>{'fcmToken': token},
      SetOptions(merge: true),
    );
  }

  Future<void> saveNotificationSettings({
    required bool enabled,
    required List<String> hourTimes,
  }) async {
    final String? uid = currentUid;
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
    final doc = await _firestore.collection('usernames').doc(username).get();
    return !doc.exists;
  }

  Future<void> saveProfile({
    required String displayName,
    required String username,
    required String church,
    required String city,
  }) async {
    final String? uid = currentUid;
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
  }

  Future<Map<String, dynamic>> getCurrentProfile() async {
    final String? uid = currentUid;
    if (uid == null) return <String, dynamic>{};
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data() ?? <String, dynamic>{};
  }
}
