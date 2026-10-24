# AskDocAI

Flutter document upload, chat, summaries, and quizzes with Firebase authentication.
The app is ad-free, uses email/password and Google Sign-In, and has a navy-and-blue Material 3 theme.
Android is the primary development target. Web, Windows, Linux, and macOS projects
are retained; see the validation report for platform-specific limitations. iOS
project support has been removed.

## Android development

Use Flutter 3.38.9 / Dart 3.10.8 (validated host), Android SDK 36, and Android
Studio's bundled JDK 21. The project pins AGP 8.9.1, Gradle 8.12, and Kotlin 2.1.0.
Do not use the host's standalone Java 25 for direct Gradle commands.

```powershell
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
flutter devices
flutter run -d <authorized-device-id>
```

AI features need your own Gemini key. Create an ignored `config.local.json`:

```json
{"API_KEY": "YOUR_GEMINI_API_KEY"}
```

```powershell
flutter run -d <authorized-device-id> --dart-define-from-file=config.local.json
```

The app starts without an AI key and reports missing setup when AI is requested.
An existing `.env` is preserved, but is no longer a mandatory bundled asset.
For legacy dotenv loading, explicitly register your local `.env` under Flutter
assets; prefer the ignored JSON file and Dart defines for repeatable builds.
Keys embedded in a client build are extractable; use a backend before production.

The Dart package is `askdocai`; Android/macOS/Linux identifiers use
`com.example.askdocai`. Firebase uses the existing project `askdocai-b699d` with
registered Android, web/Windows, and macOS apps. Email/password sign-in, account
creation, and password reset are available alongside Google Sign-In. Android
debug signing fingerprints are registered; release certificates still need to
be registered when release signing is configured. See
[package rename and Firebase setup](docs/PACKAGE_RENAME_AND_FIREBASE_SETUP.md).

## Change and validation records

- [Package rename and Firebase backend setup](docs/PACKAGE_RENAME_AND_FIREBASE_SETUP.md)
- [Ad-free blue theme refactor](docs/AD_FREE_THEME_REFACTOR.md)

- [Android migration report](docs/ANDROID_MIGRATION_REPORT.md)
- [Individual file staging guide](docs/FILE_BY_FILE_GIT_GUIDE.md)

Release signing still requires owner configuration.
