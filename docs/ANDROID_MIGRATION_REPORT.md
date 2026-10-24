> Historical record of the earlier Android migration. Ads and Apple authentication described here were subsequently removed. See [the current refactor report](AD_FREE_THEME_REFACTOR.md) for the current implementation and verification. Older staging instructions are not a current complete change inventory.

# Android stabilization, iOS removal and repository validation

Date: 24 October 2026 (Asia/Karachi). Repository: AskDocAI; Dart package and app identity remain docusense_ai / DocuSense AI.

## A. Executive summary

Focused changes fix cross-drive Kotlin caches and excessive Gradle/compiler memory use, native ad construction, unsupported-platform ad startup, missing optional AI configuration, sign-in dialog lifecycle, logout ordering, auth subscription disposal, splash timer lifetime, PDF provider replacement during upload, and text/Markdown byte loading. Apple authentication is adapted to Firebase's cross-platform provider flow; Google and Apple UI remain.

All 43 tracked iOS-only files are deleted, along with the iOS metadata/Firebase mapping and three sign_in_with_apple lockfile entries. Ignored local iOS generated files are deliberately preserved and ignored at the root. No shared document assets or retained platform projects were deleted.

Web compilation passed. Four regression tests passed (three authentication widget tests and one missing-AI-configuration test). Default analysis remains nonzero because of 36 existing informational lints, down from 53 baseline findings (including a missing-asset warning). Android debug builds and physical-device startup passed; interactive phone testing was blocked by INJECT_EVENTS permission. Detailed evidence is recorded in D/F and the final addendum. Compilation alone does not establish account login or AI correctness.

No files were staged or committed. Existing user work is preserved.

## B. Initial repository and environment state

### Git safety record

Branch: main. Initial `git status --short` and `git status --short --untracked-files=all` listed these seven unstaged modified files, with no staged or untracked files:

```text
 M linux/flutter/generated_plugin_registrant.cc
 M linux/flutter/generated_plugin_registrant.h
 M linux/flutter/generated_plugins.cmake
 M macos/Flutter/GeneratedPluginRegistrant.swift
 M windows/flutter/generated_plugin_registrant.cc
 M windows/flutter/generated_plugin_registrant.h
 M windows/flutter/generated_plugins.cmake
```

Initial `git diff --stat`, `git diff` and `git diff --cached` showed no semantic content changes; Git emitted LF/CRLF warnings. These pre-existing statuses were not reset. Full tracked-file inventory was read with `git ls-files`. No AGENTS.md was found in the project search. The macOS registrant subsequently acquired the expected generated removal of the Apple plugin; its pre-existing modified status means selective staging is recommended.

Ignored local state included .dart_tool, build, Flutter plugin metadata, android/local.properties, Android generated Java registrant, desktop ephemeral folders and iOS generated settings/registrants. These were preserved. No .env existed. No signing keys, environment credentials or SDK paths were added to tracked configuration.

### Environment and dependency findings

| Item | Observed configuration |
| --- | --- |
| Flutter / Dart | Flutter 3.38.9 stable, revision 67323de285; Dart 3.10.8; DevTools 2.51.1 |
| SDK constraints | Dart ^3.9.2; lockfile Flutter >=3.35.0 |
| OS | Windows 11, 10.0.26200.9711 |
| Java on PATH | Oracle Java 25.0.2; direct Gradle commands should not use this |
| Flutter Android Java | Android Studio bundled JetBrains JDK 21.0.8 |
| Android SDK | C:\\Users\\abdul\\AppData\\Local\\Android\\sdk; platform 36; build tools 35.0.0 and 36.1.0; licenses accepted |
| Flutter SDK defaults | compileSdk 36, targetSdk 36, minSdk 24, NDK 28.2.13676358 (from installed FlutterExtension source) |
| Android plugins | AGP 8.9.1; Kotlin Gradle plugin 2.1.0; Google Services 4.3.15 |
| Wrapper | Gradle 8.12 all; unchanged; its bundled Kotlin 2.0.21 is separate from the project's Kotlin plugin |
| JVM bytecode target | Existing Java/Kotlin target 11; unchanged |
| Firebase | firebase_core 4.2.0, firebase_auth 6.1.1 |
| Authentication | google_sign_in 6.3.0 locked; sign_in_with_apple 7.0.1 replaced by existing Firebase provider API |
| Other relevant packages | google_mobile_ads 6.0.0, file_picker 10.3.3, doc_text_extractor 1.0.0, google_generative_ai 0.4.7, provider 6.1.5+1, flutter_dotenv 6.0.0 |
| Device | 23053RN02A / fire_global, serial 0a39ba727d73, authorized, Android 15 API 35, arm64 |
| Other host tools | Chrome, Edge and Visual Studio Community 2026 available; flutter doctor -v reported no issues |

No arbitrary SDK/dependency upgrades were made. Existing namespace, applicationId and Kotlin package match: com.example.docusense_ai. MainActivity extends FlutterActivity; exported launch activity, embedding, styles and launcher resources are present. Cleartext traffic remains disabled by default. Main manifest now explicitly declares INTERNET, instead of depending on debug/profile manifests or transitive plugin manifests. Release configuration still uses debug signing, so this is not production-ready signing.

Firebase Android JSON and Dart options agree on the configured project and Android app. The JSON has no OAuth client entries; supplying refreshed Google client configuration and registering certificate fingerprints remain required. Firebase console provider enablement cannot be inferred from files. Linux Firebase options are explicitly unconfigured, a pre-existing runtime limitation. macOS retains its existing Apple-platform Firebase fields; its app/bundle match still needs validation on macOS.

### Authentication trace

Home is reachable while signed out; uploading opens a Google/Apple dialog. Firebase authStateChanges and currentUser drive persistent login state. The dialog now reports success only after a completed provider login. Upload still requires a second tap after successful login, matching the existing interaction. Logout awaits Firebase, clears current document/selection/summary, and attempts native Google cleanup only on supported platforms. Recent-file history is preserved. There is no email/password login, registration or password-reset implementation to validate. No new provider, credentials, accounts or backend data were created.

## C. Changes made

There are 71 task-touched paths (43 deletions and 28 added/modified paths), and no moved files. Every task-touched path is listed below, including individual deleted binary assets. The six pre-existing desktop-only modified files without semantic task changes are excluded from this task inventory and retained in H.

| Path | Type | Change / reason | Impact | Validation |
| --- | --- | --- | --- | --- |
| `android/app/src/main/res/values/styles.xml` | modified | NormalTheme now derives from Theme.AppCompat.Light.NoActionBar after a native ad AppCompatButton warning on the phone. | Preserves light/no-action-bar behavior and launch theme. | APK rebuild and relaunch; see addendum. |
| `android/app/src/main/res/values-night/styles.xml` | modified | Night NormalTheme derives from Theme.AppCompat.NoActionBar for matching native widget compatibility. | Preserves dark/no-action-bar behavior; no dark-mode toggle during testing. | Resource compilation; see addendum. |
| `android/.gitignore` | modified | Ignore /.kotlin/ after compiler sessions appeared as untracked generated output. | Local sessions preserved; no runtime effect. | Git status/ignore review. |
| `android/gradle.properties` | modified | Disable cross-drive Kotlin incremental compilation; lower Gradle heap/metaspace/code cache, cap workers at two, and use in-process Kotlin compilation after a confirmed native-memory crash. | Slower/lower-memory builds; runtime and toolchain versions unchanged. | Final Android rebuild after configuration change; see addendum. |
| `.gitignore` | modified | Keep local iOS leftovers and config.local.json ignored; replace obsolete iOS build-id rule. Preserve local files and prevent credentials or removed platform caches being added. | Local-only files remain on disk. | Git ignore/status review. |
| `.metadata` | modified | Remove iOS migration entry and unmanaged Xcode-project path. Flutter metadata must match retained targets. | Other platform metadata is retained. | Diff inspection. |
| `README.md` | modified | Replace starter text with actual Android and Firebase setup and report links. Make development and remaining setup reproducible. | Documents optional AI configuration and existing platform limits. | Commands cross-checked against executed validation. |
| `android/app/src/main/AndroidManifest.xml` | modified | Declare INTERNET in the main manifest. Firebase, AI and ads need networking outside debug/profile builds. | Release variants gain required network access; no cleartext allowance added. | Manifest inspection; Android build attempted. |
| `firebase.json` | modified | Remove only the iOS FlutterFire configuration mapping. Stop maintaining an iOS Firebase target. | Android and macOS mappings retained. | JSON parsing and diff inspection. |
| `ios/.gitignore` | deleted | Remove iOS native runner configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Flutter/AppFrameworkInfo.plist` | deleted | Remove iOS Flutter build settings. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Flutter/Debug.xcconfig` | deleted | Remove iOS Flutter build settings. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Flutter/Release.xcconfig` | deleted | Remove iOS Flutter build settings. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Podfile` | deleted | Remove iOS CocoaPods dependency configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Podfile.lock` | deleted | Remove iOS CocoaPods dependency configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner.xcodeproj/project.pbxproj` | deleted | Remove Xcode project/workspace configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner.xcodeproj/project.xcworkspace/contents.xcworkspacedata` | deleted | Remove Xcode project/workspace configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist` | deleted | Remove Xcode project/workspace configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings` | deleted | Remove Xcode project/workspace configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme` | deleted | Remove Xcode project/workspace configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner.xcworkspace/contents.xcworkspacedata` | deleted | Remove iOS native runner configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist` | deleted | Remove iOS native runner configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings` | deleted | Remove iOS native runner configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/AppDelegate.swift` | deleted | Remove iOS native runner configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md` | deleted | Remove iOS-only icon/launch asset. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Base.lproj/LaunchScreen.storyboard` | deleted | Remove iOS native runner configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Base.lproj/Main.storyboard` | deleted | Remove iOS native runner configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/GoogleService-Info.plist` | deleted | Remove iOS Firebase plist. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Info.plist` | deleted | Remove iOS native runner configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Runner-Bridging-Header.h` | deleted | Remove iOS native runner configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/Runner/Runner.entitlements` | deleted | Remove iOS native runner configuration. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `ios/RunnerTests/RunnerTests.swift` | deleted | Remove iOS native test. Remove the requested iOS project support. | Affects iOS only; shared assets and retained platform files untouched. | Tracked-path inventory and final deletion review. |
| `lib/Auth/apple_auth.dart` | modified | Use Firebase AppleAuthProvider popup/native provider flows instead of iOS-oriented credential plugin. Retain Apple authentication after removing iOS-specific implementation. | Apple provider console setup remains required; no live login claimed. | Analysis and dialog regression tests; API checked in installed Firebase source. |
| `lib/Auth/google_auth.dart` | modified | Use Firebase popup on web and provider flow on Windows; retain native Google plugin elsewhere. Avoid invoking unsupported Google plugin implementations on retained targets. | Actual account login still requires OAuth setup. | Static analysis; no credentialed login. |
| `lib/Auth/google_sign_out.dart` | modified | Capture providers before awaits, await Firebase logout, clear document selection/summary and guard Google session cleanup by platform. Avoid stale dialog-context access and inconsistent local logout state. | Firebase auth stream remains authoritative; recent-file list preserved. | Static analysis and call-site inspection; live logout untested. |
| `lib/firebase_options.dart` | modified | Delete iOS options and explicitly reject iOS initialization. Remove iOS-only Firebase configuration. | macOS Firebase app ID and iosBundleId are necessary Apple-platform fields and retained. | Static analysis and diff inspection. |
| `lib/main.dart` | modified | Initialize ads only on Android; load dotenv optionally; retain PdfProvider across file updates and use the shared FileProvider. Prevent unsupported-platform startup calls, missing-config startup failures and provider state replacement during file processing. | Existing routes, languages, Firebase and UI remain. | Static analysis, tests and target build attempts. |
| `lib/providers/auth_state.dart` | modified | Store and cancel the auth state stream subscription on disposal. Prevent notifications from outliving the provider. | Firebase persistence and auth state stream unchanged. | Static analysis and lifecycle inspection. |
| `lib/screens/home/home_screen.dart` | modified | Render native ad only after load; dispose and clear failed ads. Prevent missing-template startup crash and premature native ad rendering. | Home content still works if an ad is unavailable. | Static analysis and template API inspection; Phone startup and native test-ad rendering verified; no interactive input allowed. |
| `lib/screens/signin_screen.dart` | modified | Keep dialog mounted during provider login, disable duplicate/cancel actions while busy, return true only after success and present retryable errors. Old dialog returned success before login and reused its disposed context. | Google and Apple buttons retained; explicit Cancel remains available. | Three authentication widget regression tests passed. |
| `lib/screens/splash/splash_screen.dart` | modified | Cancel progress timer and check mounted before timer updates/navigation. Prevent delayed callbacks accessing disposed splash state. | Same splash timing and navigation behavior. | Static analysis and lifecycle inspection. |
| `lib/utils/ads_manager.dart` | modified | Guard ad creation/loading to Android; add native small template and use a test interstitial unit of the correct format. Fix invalid native ad construction and banner-unit misuse for interstitials. | Interstitial remains test-only until owner supplies production unit; desktop/web ads omitted. | Installed plugin source and official templates documentation inspected; static analysis. |
| `lib/utils/file_helper.dart` | modified | Request selected-file bytes and decode Markdown like plain text. Picker did not request bytes for text and accepted Markdown without reading it. | More memory used for selected binary documents; extraction paths retained. | Static analysis; physical file picker not yet verified. |
| `lib/utils/gemini_service.dart` | modified | Read API_KEY from Dart defines with legacy dotenv fallback; return explicit setup message when missing. Remove fabricated fallback API key and misleading service-demand message for absent configuration. | AI still requires valid external key; existing prompts/model unchanged. | Static analysis; external Gemini requests untested. |
| `lib/widgets/app_bar.dart` | modified | Separate parent/dialog context and await logout with visible failure feedback. Avoid optimistic local logout and stale context after confirmation closes. | Sign-in/out actions and language selector retained. | Static analysis and call-site review. |
| `macos/Flutter/GeneratedPluginRegistrant.swift` | modified | Flutter regeneration removes sign_in_with_apple import/registration. Dependency now replaced by Firebase provider API. | Pre-existing modified file: selectively stage task hunks only; all other registrations preserved. | Generated diff inspection. |
| `pubspec.lock` | modified | Remove only three sign_in_with_apple package entries. Keep lockfile synchronized with focused dependency removal. | Other pinned dependency versions unchanged. | flutter pub get succeeded. |
| `pubspec.yaml` | modified | Remove sign_in_with_apple and mandatory .env asset; remove obsolete iOS version comments. Stop iOS credential plugin dependency and missing .env build failure. | Legacy .env can be explicitly registered locally; prefer Dart define JSON. Shared Cupertino dependency retained. | Dependency resolution, static analysis and tests. |
| `test/signin_dialog_test.dart` | added | Add tests for pending authentication, retryable failure, Apple provider exception and missing AI configuration. Protect sign-in dialog lifecycle, success-return fixes and missing AI setup handling. | Uses injected fake callbacks; does not prove real Firebase login. | flutter test: four passed (including missing AI setup). |
| `docs/ANDROID_MIGRATION_REPORT.md` | added | Record baseline, environment, changes, validation, device evidence and outstanding setup. Provide a reproducible audit of this task. | Documentation only. | Manual consistency review and git diff --check. |
| `docs/FILE_BY_FILE_GIT_GUIDE.md` | added | Document each individual staging command, commit suggestion and ordering. Allow deliberate per-file review without automatic staging. | Documentation only; commands are suggestions and have not been executed. | Inventory compared with Git changes. |


### iOS classification and retained references

Xcode workspaces/projects, CocoaPods files, Flutter iOS settings, runner Swift/Objective-C bridge, plists, entitlements, storyboards, icons and iOS native test are exclusively iOS and removed. No ignored local generated file was deleted. Root /ios/ ignores those leftovers to prevent accidental reintroduction.

Apple provider strings and localization keys remain because Apple sign-in remains available on retained platforms. Cupertino widgets/icons/localization delegates are shared Flutter UI and remain. google_sign_in_ios, shared_preferences_foundation and other transitive Apple-platform packages remain because macOS needs them. macOS Firebase app IDs containing ':ios:' and the iosBundleId SDK field identify an Apple-platform Firebase app, not an iOS runner directory. Generated localization documentation may mention an Xcode iOS workspace; it is upstream generated boilerplate, not an active build/setup instruction.

## D. Commands and validation results

Commands are in execution order by phase; independent checks overlap. PowerShell reads/searches inspected the files listed in B/C. Exit statuses are recorded for validation commands; output redirection and polling do not change the command being validated.

| Exact command | Purpose | Phase | Result / exit | Relevant output and classification |
| --- | --- | --- | --- | --- |
| `git status --short` | Initial work | Baseline | Pass, 0 | Seven pre-existing modified plugin files |
| `git branch --show-current` | Branch | Baseline | Pass, 0 | main |
| `git diff --stat`; `git diff`; `git diff --cached` | Inspect modifications/index | Baseline | Pass, 0 | No semantic diffs; LF/CRLF notices |
| `git ls-files`; `git status --short --untracked-files=all` | Tracked/untracked inventory | Baseline | Pass, 0 | No initial untracked files |
| `rg --files -g AGENTS.md -g '!build' -g '!node_modules'` | Repository instructions | Baseline | No matches, 1 | No repository AGENTS.md |
| `Get-Command flutter,dart,java,adb -ErrorAction SilentlyContinue` | Tool locations | Baseline | Pass | Executables found |
| `flutter --version` | SDK versions | Baseline | Pass, 0 outside sandbox | Flutter 3.38.9 / Dart 3.10.8; initial restricted attempt stalled and was stopped |
| `flutter doctor -v` | Environment | Baseline | Pass, 0 outside sandbox | No issues; restricted combined attempt stalled |
| `java -version` | PATH Java | Baseline | Pass, 0 outside sandbox | Java 25.0.2; Flutter uses JDK 21 |
| `adb version`; `adb devices -l` | Device/tool | Baseline | Pass, 0 | adb 1.0.41 / platform-tools 36.0.0; authorized physical device |
| `git status --ignored --short` | Local config safety | Baseline | Pass, 0 | Local config/generated files inspected and preserved |
| `flutter pub get` | Resolve baseline | Baseline | Pass, 0 outside sandbox | No dependency changes; 102 newer incompatible versions informational only |
| `flutter analyze` | Static baseline | Baseline | Fail, 1 | 53 issues: 52 infos, one missing .env asset warning; no compile errors. Log: %TEMP%/askdoc-baseline-analyze.log |
| `flutter test` | Test baseline | Baseline | Fail, 1 | Test directory "test" not found; pre-existing absence |
| `flutter build apk --debug` | Android baseline | Baseline | Blocked, 1 after task-owned process stopped | Gradle distribution remained unavailable during baseline; 217.7s. Log: %TEMP%/askdoc-baseline-build.log. Environment limitation, not a proven project compile failure |
| `flutter build apk --debug --no-pub` | Direct-output baseline retry | Baseline diagnostic | Blocked, 1 after stop | 77.3s; no successful APK |
| `curl.exe -I -L --max-time 30 https://services.gradle.org/distributions/gradle-8.12-all.zip` | Reachability | Diagnostic | Pass, 0 | HTTP 200 after redirects; 229762718-byte archive |
| `$env:JAVA_HOME = 'C:\\Program Files\\Android\\Android Studio\\jbr'; .\\gradlew.bat --version` (cwd android) | Recover wrapper / inspect actual JDK | Diagnostic | Pass, 0 | Download/unzip completed; Gradle 8.12 / JDK 21 |
| `flutter pub get` | Focused dependency removal | Final | Pass, 0 | Only three sign_in_with_apple entries removed; no upgrades |
| `dart format lib/Auth/apple_auth.dart lib/Auth/google_auth.dart lib/Auth/google_sign_out.dart lib/firebase_options.dart lib/main.dart lib/providers/auth_state.dart lib/screens/home/home_screen.dart lib/screens/signin_screen.dart lib/screens/splash/splash_screen.dart lib/utils/ads_manager.dart lib/utils/file_helper.dart lib/utils/gemini_service.dart lib/widgets/app_bar.dart test/signin_dialog_test.dart` | Format changed Dart | Final | Pass, 0 | 14 files checked; 12 formatted. Executed via installed SDK absolute dart.exe |
| `flutter test` | First regression run | Final intermediate | Fail, 1 | Two passed; Apple test finder did not match private ElevatedButton.icon subclass. Test finder corrected; app implementation not implicated |
| `flutter analyze` | Intermediate analysis | Final intermediate | Fail, 1 | Concurrent edit run duplicated some diagnostics (55 reported); superseded by stable run |
| `flutter build apk --debug` | First final APK attempt | Final intermediate | Fail, 1 | Two 120000ms exclusive-access timeouts while wrapper download was running; task-created lock contention, environment limitation |
| `flutter build web` | Retained web compilation | Final | Pass, 0 | Built build/web in 353.4s; Wasm dry run succeeded; no browser runtime claim |
| `curl.exe -fL --max-time 180 -o "$env:TEMP\\askdoc-gradle-8.12-all.zip" https://services.gradle.org/distributions/gradle-8.12-all.zip` | Bounded alternate download | Diagnostic | Timeout, 28 | Partial 171914158/229762718 bytes; temporary file only |
| `curl.exe -sS -fL -C - --max-time 180 -o "$env:TEMP\\askdoc-gradle-8.12-all.zip" https://services.gradle.org/distributions/gradle-8.12-all.zip` | Resume alternate download | Diagnostic | Pass, 0 | Archive complete |
| `curl.exe -sS -fL --max-time 30 -o "$env:TEMP\\askdoc-gradle-8.12-all.zip.sha256" https://services.gradle.org/distributions/gradle-8.12-all.zip.sha256`; `Get-FileHash "$env:TEMP\\askdoc-gradle-8.12-all.zip" -Algorithm SHA256` | Distribution integrity | Diagnostic | Pass, 0 | Official SHA256 matched 7EBDAC923867A3CEC0098302416D1E3C6C0C729FC4E2E05C10637A8AF33A76C5; wrapper independently completed normal cache install |
| `& 'C:\\Users\\abdul\\.gradle\\wrapper\\dists\\gradle-8.14-all\\c2qonpi39x1mddn7hk5gh9iqj\\gradle-8.14\\bin\\gradle.bat' -p android -Ptarget=lib/main.dart -Ptarget-platform=android-arm64 assembleDebug --console=plain` | Cached Gradle fallback | Diagnostic | Stopped, not passed | Temporary task-owned client/daemon stopped once pinned 8.12 was available; repository wrapper unchanged |
| `flutter test` | Corrected regression tests | Final | Pass, 0 | Three tests passed |
| `flutter analyze` | Stable default analysis | Final | Fail, 1 | 36 pre-existing informational findings; no warnings/errors; not described as a passing default analyzer |
| `flutter devices` | Flutter device inventory | Final | Pass, 0 | Physical Android, Windows, Chrome, Edge |
| `flutter analyze --no-fatal-infos` | Error/warning gate | Final | See final verification addendum | Infos retained rather than suppressed in source |
| `adb -s 0a39ba727d73 shell getprop ro.build.version.release`; `adb -s 0a39ba727d73 shell pm list packages com.example.docusense_ai` | Inspect phone / existing install | Final | Pass, 0 | Android 15; package not initially installed |
| `git diff --check`; `git diff --stat`; `git status --short --untracked-files=all`; `git diff` | Final review | Final | See final verification addendum | Review includes untracked docs/tests and pre-existing files |
| `flutter build apk --debug` | Pinned wrapper retry after download | Final | See final verification addendum | No APK success claimed until command completes |

Additional diagnostics used `Get-CimInstance Win32_Process`, `Get-Process`, `Get-Content`, `Get-ChildItem`, installed JDK `jstack.exe` and `Select-String` to inspect task-owned processes, build logs, wrapper cache and thread waits. Initial restricted CIM access failed; elevated inspection succeeded. Only task-owned stalled commands/fallback processes were stopped, with no global process kill or cache deletion. No staging commands in the companion guide were executed.

## E. Android and Firebase setup

Use Flutter's bundled Android Studio JDK 21. Direct Gradle usage in PowerShell should set JAVA_HOME to that JDK for the current shell. Keep machine paths in ignored android/local.properties. Installed SDK/build tools and licenses pass flutter doctor. SDK/NDK downloads may still occur on a clean build. The project pins AGP 8.9.1 / Gradle 8.12 / Kotlin 2.1.0; no compatibility upgrade was shown necessary during inspection.

Create ignored config.local.json containing your real API_KEY, then use:

```powershell
flutter pub get
flutter test
flutter analyze
flutter build apk --debug --dart-define-from-file=config.local.json
flutter run -d 0a39ba727d73 --dart-define-from-file=config.local.json
```

Do not commit the JSON, .env, signing keys or local.properties. Client-side defines are embedded in distributable binaries; use a backend/key restrictions before production. Existing .env remains supported only if explicitly bundled locally; it is no longer required by pubspec. A missing key does not prevent startup, and AI service functions report missing setup when invoked.

For Google auth: enable Google in Firebase Authentication, register the actual debug/release signing SHA-1/SHA-256 fingerprints for the existing Android app, and download updated android/app/google-services.json with Android/web OAuth client entries. The current JSON has none. Do not rename the application ID without registering the corresponding Firebase app. Provider enablement, restrictions and project ownership require owner verification.

For Apple auth: retain and enable the Firebase Apple provider, supply valid Apple team/key/service configuration in the console, and configure authorized redirect domains/URLs for browser-based flows. No Apple secret or service ID was invented. Existing macOS native Firebase configuration remains unverified. For web, authorize the serving domain and enable the providers. Linux currently has no Firebase target/plugin setup and therefore is not runtime-ready; its project files are preserved.

For release: supply your signing config locally and replace debug signing deliberately. The manifest retains a test AdMob application ID; interstitial uses a correct-format test unit. Existing production banner/native/rewarded identifiers require owner validation by format/application before publishing. Rewarded-ad dependent extra prompts on unsupported ad platforms remain a pre-existing functional limitation; do not claim ad parity there.

Device setup: enable developer options and USB debugging, authorize the host, then inspect `adb devices -l` and `flutter devices`. Serial above is observed, not guessed. If the phone is disconnected later, choose the serial returned by those commands.

## F. Physical-device test results

The phone is connected and authorized. It was identified through adb and Flutter. No pre-existing installed package was detected. Installation, launch and runtime/UI test outcomes are recorded in the final verification addendum below. Widget tests use fake provider callbacks; they are not physical-device tests or proof of Firebase account authentication.

Real Google/Apple login, logout persistence after a real login, uploads through an authenticated account, Gemini chat, summary and quiz responses require external provider/key setup and an interactive account. No credentials or user data were fabricated. No account creation, provider-console change or destructive device action was performed.

If installation cannot complete, local reproduction after resolving the build blocker is:

```powershell
flutter build apk --debug
flutter install --debug -d 0a39ba727d73
flutter run -d 0a39ba727d73 --dart-define-from-file=config.local.json
flutter logs -d 0a39ba727d73
```

These reproduction commands are instructions, not claims of execution.

## G. Remaining issues and recommendations

Confirmed project-specific setup: missing Gemini API key, absent OAuth clients in Android Firebase JSON, unverified external Google/Apple provider enablement, debug release signing, test/production ad configuration requiring owner validation. No server-authentication success is inferred from a build.

Pre-existing source findings: 36 informational lints remain (deprecated withOpacity, print calls, naming and async-context diagnostics in chat/quiz). They are documented rather than silenced or expanded into a broad refactor. PDF/DOC extraction on web is path-based in the existing helper; only text/Markdown bytes can be handled directly there. Linux Firebase is unconfigured. Windows/macOS/Linux were not natively built or run during this task. macOS requires a macOS host for full validation.

Fixed failures: missing .env asset warning and mandatory startup load, native ad template assertion by inspection, sign-in lifecycle errors, premature logout state, auth stream/timer disposal, invalid interstitial format, and PDF provider identity replacement during upload. The new test finder failure was introduced by this task and fixed before the passing run. Gradle lock/download failures are environment/task concurrency limitations, not proven source incompatibilities.

Optional improvements outside this task: reduce remaining informational lints, add meaningful document extraction/state tests, validate memory behavior for very large documents now that picker bytes are requested, complete retained-platform integration tests, configure release signing and production ad formats, and move external AI credentials behind a backend.

## H. Final Git status and review boundaries

All changes are unstaged. No commits/pushes/amends, reset, clean, stash or data deletion were performed. The task inventory contains 43 tracked deletions and 28 added/modified paths (including both reports and the test). Six original desktop plugin files remain untouched by task semantics; macOS plugin generation changes coexist with its pre-existing modified status.

Final intended untracked files: test/signin_dialog_test.dart, docs/ANDROID_MIGRATION_REPORT.md, docs/FILE_BY_FILE_GIT_GUIDE.md. Build output and local configuration stay ignored. No renames/moves or unexpected asset removals are intended. The companion guide contains one explicit staging command for every task file and logical commit suggestions; the macOS registrant uses selective hunk staging.

## Reference material consulted

- [Firebase federated authentication](https://firebase.google.com/docs/auth/flutter/federated-auth): provider flows and platform setup.
- [Google Mobile Ads native ads](https://developers.google.com/admob/flutter/native): template/custom-layout requirement. Installed 6.0.0 source independently confirms the NativeAd constructor assertion.
- [Gradle 8.14 release notes](https://docs.gradle.org/8.14/release-notes.html): temporary diagnostic fallback context; no repository upgrade made.
- [Android Gradle plugin configuration](https://developer.android.com/build/releases/about-agp): toolchain compatibility context.

Installed Flutter, Firebase and ad package source was inspected before choosing APIs. No external content was treated as repository instructions.

## Final verification addendum

**Final assessment: ready for Android debug development and startup testing, with external-service and manual interaction verification still outstanding.** The final debug APK builds, installs and launches on the authorized phone. The signed-out home screen and native test ad are present. No Flutter error, fatal exception or AppCompat theme warning was found in the final process log snapshot. This is limited startup evidence, not a claim that authentication, uploads or AI features work end to end.

| Final check / exact command | Result | Evidence / limits |
| --- | --- | --- |
| `flutter pub get` | Pass, exit 0 | Only the three removed Apple-plugin packages changed in the lockfile; no upgrade |
| `flutter test` | Pass, exit 0 | Four tests: three sign-in widget cases and missing AI configuration across chat/summary/quiz |
| `flutter analyze` | Nonzero due to infos | 36 pre-existing informational lints, no errors/warnings; final rerun: exit 1, 36 infos, 113.6 seconds |
| `flutter analyze --no-fatal-infos` | Pass, exit 0 | Same 36 infos; no source suppression |
| `flutter build web` (final Dart source) | Pass, exit 0 | build/web; 226.8 seconds; no browser runtime test |
| `flutter build apk --debug` (memory/cache fixes) | Pass, exit 0 | 289.3 seconds; no repeated Kotlin cross-drive failure or JVM crash |
| `flutter run --debug --no-resident --use-application-binary=build/app/outputs/flutter-apk/app-debug.apk -d 0a39ba727d73` | Pass, exit 0 | First installation 25.2 seconds; launch and home/native test ad observed |
| `adb -s 0a39ba727d73 shell input tap 800 180` | Blocked | Device SecurityException: `Injecting input events requires ... INJECT_EVENTS permission`. The later UI-read command in the compound shell succeeded; that does not make the tap successful |
| `flutter build apk --debug` (AppCompat theme fix) | Pass, exit 0 | Final APK rebuilt in 29.5 seconds |
| `flutter run --debug --no-resident --use-application-binary=build/app/outputs/flutter-apk/app-debug.apk -d 0a39ba727d73` (final APK) | Pass, exit 0 | Reinstallation 7.6 seconds; app launched, Flutter files synced; same signing identity, no data clearing |
| `adb -s 0a39ba727d73 shell pidof -s com.example.docusense_ai` | Pass | Final process alive, observed PID 23973 |
| `adb -s 0a39ba727d73 logcat -d --pid=23973` | Pass, read-only | Captured process log: 0 E/flutter lines, 0 FATAL EXCEPTION lines, 0 ThemeUtils warnings; only the captured interval is assessed |
| `adb -s 0a39ba727d73 shell uiautomator dump /data/local/tmp/askdoc-ui.xml`; `adb -s 0a39ba727d73 shell cat /data/local/tmp/askdoc-ui.xml` | Pass, read-only | App-filtered XML showed title, Sign In, upload controls, Home/Chat/Summary/Quiz and native test ad; an initial read before installation completed saw the launcher and was not counted as app evidence |
| `git diff --check` | Pass, exit 0 | No whitespace errors; existing LF/CRLF conversion notices remain |
| `git diff --stat`; `git status --short --untracked-files=all`; `git diff --cached --stat`; `git diff` | Reviewed | 68 tracked task diffs plus three untracked deliverables = 71 task paths; six other original modified statuses retained; index empty |
| `git check-ignore config.local.json ios/Flutter/Generated.xcconfig`; `git check-ignore android/.kotlin/sessions/kotlin-compiler-9428139439341945644.salive android/hs_err_pid13408.log` | Pass | Local config, iOS leftovers, compiler sessions and crash log remain ignored/preserved |
| `curl.exe -sS -I --max-time 20 https://dl.google.com/dl/android/maven2/com/android/tools/build/gradle/8.9.1/gradle-8.9.1.pom` | Pass | HTTP 200; Google Maven reachable during long dependency setup |

APK: `build/app/outputs/flutter-apk/app-debug.apk`. The app remains installed and running for the owner to inspect. A small temporary UI dump remains at `/data/local/tmp/askdoc-ui.xml` on the phone; no user files were deleted.

**Physical-device scope:** installation, launch, process survival, signed-out home UI presence and native test ad rendering verified. No tap-driven navigation, provider login, logout, document upload, chat response, summary generation, quiz interaction or login persistence test succeeded on the phone; input injection was denied before any provider flow could be opened. These need manual interaction on the phone (ordinary touches do not require enabling ADB input injection) after owner Firebase/Gemini setup. No phone security setting was changed or bypassed.

**Remaining runtime observations:** debug cold start emitted skipped-frame messages (including 204 skipped frames); profile-mode performance investigation remains appropriate before release. AdMob warns that its optional Firebase integration is unavailable/missing/outdated; this is not evidence of Firebase Authentication failure, and no unrelated Analytics/dependency upgrade was made just to silence it. OEM MIUI logging/property warnings were also observed. The earlier AppCompat native-widget theme warning was fixed by light/night NormalTheme parents and absent from the final log snapshot. Dark-mode switching was not manually tested.

**Checks not executed:** release APK/appbundle and native Windows/macOS/Linux builds were skipped; release signing/production ad setup remains incomplete and this task validated debug Android plus web compilation. Real external-service tests require owner credentials/configuration. No unsuccessful or unexecuted check is marked passed.

The pinned-wrapper build progressed beyond dependency setup and exposed actual Kotlin incremental cache errors in shared_preferences_android, file_picker and webview_flutter_android: `this and base files have different roots` (C: pub cache versus A: checkout). Compiler fallback also emitted third-party deprecation/unchecked-cast warnings. `android/gradle.properties` now disables Kotlin incremental compilation; a subsequent build invocation validates that workaround. No caches were deleted. At that intermediate stage the inventory was 68 paths; subsequent memory/artifact-ignore and theme fixes bring the final total to 71.

[Kotlin's documented incremental compilation switch](https://kotlinlang.org/docs/gradle-compilation-and-caches.html) confirms `kotlin.incremental=false` is supported for Kotlin/JVM.

The first pinned-wrapper retry ultimately failed (exit 1, 1208.7 seconds) with `Gradle build daemon disappeared unexpectedly`. Its ignored crash log `android/hs_err_pid13408.log` confirms native memory allocation failure: the original Gradle JVM allowed an 8 GB heap and 4 GB metaspace on a host with about 8 GB RAM (495 MB free in the crash log). This is a confirmed environment/configuration limitation; concurrent validation and compiler daemons also contributed to memory pressure. The crash log remains locally preserved and ignored. Two compiler daemons spawned by this task's crashed process were identified by parent PID and stopped; no unrelated processes were stopped. Gradle now uses 2 GB heap, 1 GB metaspace, 256 MB code cache, two workers, and in-process Kotlin compilation. A new sequential Android debug build validates these settings. Web recompiled successfully against the final Dart source (exit 0, 226.8 seconds). Four regression tests pass. The final inventory, including the subsequent light/night theme corrections, is 71 task paths: 43 deletions and 28 added/modified paths.

