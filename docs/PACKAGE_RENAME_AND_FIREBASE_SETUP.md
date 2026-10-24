# AskDocAI package and Firebase setup

Updated: 24 October 2026.

The local rename and Firebase app registration are complete. The user selected the existing Firebase project **askdocai-b699d**, replacing the earlier inaccessible vault-99bd4 target. Configuration was retrieved from actual Firebase registrations; no app IDs or keys were invented. Previous-project users and data were not migrated or deleted.

| Identity | Value |
| --- | --- |
| Display name | AskDocAI |
| Dart package | askdocai |
| Android application ID / namespace | com.example.askdocai |
| macOS bundle ID | com.example.askdocai |
| Linux application ID | com.example.askdocai |
| Windows/Linux executable | askdocai |
| Firebase project | askdocai-b699d |
| Android Firebase app | 1:5628303335:android:e1339ba542a2c2eb048f42 |
| Web/Windows Firebase app | 1:5628303335:web:e6d343f1c56d3ffd048f42 |
| macOS Firebase app | 1:5628303335:ios:f38f4bd787d65fa9048f42 |
| Firestore database | askdocai (Enterprise native, realtime enabled) |
| Database location | asia-south1 (Mumbai), selected by the user |

Firebase calls macOS registrations IOS; this does not restore the removed iOS Flutter project or Apple Sign-In.

## Authentication

Email/password and Google providers are enabled in the Firebase backend. The existing dialog now supports email sign-in, account creation, and password reset, with validation, busy states, retryable failures, and generic reset feedback. Existing Google sign-in remains available. Android debug SHA-1 and SHA-256 fingerprints are registered and the refreshed google-services.json contains the real OAuth clients. Register release/Play signing certificates before testing a release build.

The native identifiers establish a separate installed-app identity from the old DocuSense package. No application was uninstalled or installed during setup.

## Chat data

The Flutter app explicitly selects database `askdocai`, not `(default)`.

- `users/{uid}/chats/{documentId}`: owner UID, document name, creation/update server timestamps.
- `users/{uid}/chats/{documentId}/exchanges/{exchangeId}`: owner UID, question, answer, creation server timestamp.
- Each document ID is derived locally from its name and content. Reopening or reuploading the same document under the same account restores the latest 100 exchanges (200 messages).
- Source documents, file paths, passwords, and API keys are not uploaded to Firestore. Chat text and the document name are stored privately.
- Writes use a transaction and stable exchange IDs so retrying a completed write does not duplicate it. Parent creation and its first exchange are atomic.
- Sync failures show a retry banner. Pending failed writes remain in this screen's memory; they do not survive closing the screen or process termination. Full offline queueing and a cross-document history browser are outside this setup.
- The UI resets its chat instance when the account or selected document changes. The repository checks the current account before database operations.

Prototype rules require the matching authenticated UID, reject extra or missing fields, bound strings, protect immutable metadata, and deny exchange updates/deletes. All other paths are denied. Client-written answers are private history, not trusted server output. Rules require review before broad release.

## Configuration and validation

Configuration lives in `.firebaserc`, `firebase.json`, `lib/firebase_options.dart`, and `android/app/google-services.json`. Rules and the history index are in `firestore.rules` and `firestore.indexes.json`. The only new production dependency is cloud_firestore; existing Firebase/Auth package versions are retained.

```powershell
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter build apk --debug
```

Firebase CLI commands use the current CLI through npx:

```powershell
npx -y firebase-tools@latest firestore:databases:get askdocai --project askdocai-b699d
npx -y firebase-tools@latest deploy --only "auth,firestore" --project askdocai-b699d
```

Isolated Firebase test dependencies are in `tools/firebase-tests`; they are not Flutter production dependencies. Run the Auth and Firestore emulator tests with Node.js 24.12+ and JDK 21:

```powershell
npm ci --prefix tools/firebase-tests
$env:JAVA_HOME = 'C:\Program Files\Android\Android Studio\jbr'
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
npx -y firebase-tools@latest emulators:exec --only "auth,firestore" --project demo-askdocai "npm test --prefix tools/firebase-tests"
```

These tests use an isolated demo project and do not create production users or modify production chat data. They cover anonymous/cross-account access, atomic parent creation, the app's history query, ownership/schema/size/timestamp attacks, immutable exchanges, and email/password creation/sign-in/reset flows.

Android is the validated native target on this Windows host. Native macOS builds, entitlements/keychain configuration and Google redirect handling require validation on macOS. Windows and web runtime sign-in have not been manually exercised. Linux Firebase remains unsupported by the existing Flutter SDK setup. New authentication/sync labels are currently English. AI generation continues to use the existing Gemini API_KEY setup and was not migrated to Firebase AI Logic.

Existing unrelated changes and installed skills are preserved. No staging, commit, push, reset or deletion of the previous Firebase project was performed.

## Files changed for this backend setup

| Files | Purpose |
| --- | --- |
| AGENTS.md | Persist the user's requirement to use Firebase skills and the selected project |
| .firebaserc, firebase.json | Active project, app IDs, authentication providers, database/rules/index and emulator configuration |
| android/app/google-services.json, lib/firebase_options.dart | Authentic configuration retrieved from newly registered Firebase apps |
| lib/Auth/email_auth.dart, lib/screens/signin_screen.dart | Email/password sign-in, account creation and password reset alongside Google |
| lib/services/chat_store.dart | Named-database repository, private paths, typed exchanges, atomic and idempotent writes |
| lib/screens/chat/chat_screen.dart, widgets/chat_message_handler.dart | History restoration, saved exchanges, sync retries and disposed-screen handling |
| lib/screens/home/home_screen.dart | Reset chat state when the signed-in user or selected document changes |
| firestore.rules, firestore.indexes.json | Private schemas/access checks and the ordered history index |
| pubspec.yaml, pubspec.lock, generated macOS/Windows plugin registrants | Add cloud_firestore and its required platform implementations |
| test/email_signin_test.dart, test/chat_persistence_test.dart | Authentication UI and persistence regressions |
| tools/firebase-tests/ | Isolated Auth/Firestore emulator tests and locked test dependencies |
| README.md, this document | Setup, limitations and validation results |

## Verification results

- Firebase database create/get: confirmed Enterprise native database `askdocai` in `asia-south1`, realtime enabled and free-tier eligibility reported by Firebase. Billing was not enabled or changed.
- Authentication deployment: email/password and Google providers enabled, including the configured localhost redirect.
- Firestore rules: cloud compilation/dry run passed; deployment completed successfully. An initial upload request failed; the subsequent deployment succeeded.
- History index deployment: succeeded for the named `askdocai` database.
- `flutter pub get`: passed. Existing Firebase core/auth versions retained; cloud_firestore 6.0.3 added.
- `dart format --output=none --set-exit-if-changed lib test`: passed (63 files, zero changes).
- `flutter analyze`: no errors or warnings; exit 1 due to the same 35 existing informational lints.
- `flutter test`: all 13 tests passed, including the original ad-free/Google regressions and new email/history cases.
- Enterprise Firestore + Auth emulator suite: all five tests passed, including after the patched gRPC test dependency override.
- Test-only npm dependency audit: zero vulnerabilities after applying the compatible gRPC override.
- `flutter build apk --debug`: succeeded with the renamed package, new Firebase configuration and Firestore dependency. Output: `build/app/outputs/flutter-apk/app-debug.apk`.
- `git diff --check`: passed. Existing Git line-ending notices are informational.

No production test account or chat data was created. End-to-end sign-in on a physical Android device and native builds on other hosts were not exercised.

