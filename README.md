# Nouri (Agpeya) App

Coptic Orthodox prayer app built with Flutter, Cubit, Dio, Firebase, and Cloud Functions.

## Stack

- Flutter + `flutter_bloc` (Cubit)
- Firebase Auth / Firestore / Storage / Messaging / Functions
- `get_it` DI
- `go_router` navigation
- `share_plus`, `flutter_local_notifications`, `just_audio`
- AR/EN localization (`flutter gen-l10n`)

## Project Commands

### Flutter

- Install deps: `flutter pub get`
- Generate localizations: `flutter gen-l10n`
- Analyze: `flutter analyze`
- Test: `flutter test`

### Cloud Functions

- Install deps: `npm --prefix functions install`
- Build: `npm --prefix functions run build`
- Deploy: `firebase deploy --only functions`

### Firestore Config Deploy

- Deploy rules + indexes:
  - `firebase deploy --only firestore:rules`
  - `firebase deploy --only firestore:indexes`

## Firebase Setup Checklist

1. FlutterFire configuration is generated in `lib/firebase_options.dart`.
2. Android config is present: `android/app/google-services.json`.
3. Add iOS config if targeting iOS: `ios/Runner/GoogleService-Info.plist`.
4. Ensure `.firebaserc` project is correct (`nouri-39428`).

## Auth Provider Checklist

### Google Sign-In

- Enable Google provider in Firebase Auth.
- Android:
  - Add SHA-1/SHA-256 in Firebase console.
  - Ensure package name matches `com.nouri.nouri`.
- iOS:
  - Ensure reversed client ID and URL schemes in Xcode project.

### Apple Sign-In

- Enable Apple provider in Firebase Auth.
- Apple Developer:
  - Enable Sign in with Apple capability for app identifier.
- Xcode:
  - Add Sign In with Apple capability.

## Security

- Firestore rules are defined in `firestore.rules`.
- Firestore indexes are in `firestore.indexes.json`.
- Client never writes points directly; points are awarded in Cloud Functions.

## Cloud Functions Implemented

- `onPrayerLogged` (Firestore trigger)
- `logPrayerCallable`
- `migrateGuestLogsCallable`
- `weeklyReset`
- `monthlyReset`
- `sendPrayerReminder`

## Runtime Verification Checklist

1. Launch app, open Home.
2. Open profile sheet and change language (AR/EN) -> app direction flips immediately.
3. Sign in with Google/Apple.
4. Complete prayer hour -> log appears under `prayerLogs/{uid}/logs/{date}`.
5. Share daily card -> image share sheet opens.
6. Toggle reminders -> local schedule + Firestore settings updated.
7. Run `flutter analyze`, `flutter test`, and `npm --prefix functions run build` before deploy.
