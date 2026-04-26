import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

class FirebaseService {
  static Future<void> initialize() async {
    if (Firebase.apps.isNotEmpty) return;
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } catch (_) {
      await Firebase.initializeApp();
    }
  }
}
