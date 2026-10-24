# Ad-free Google authentication and blue theme refactor

Date: 24 October 2026.

This change continues the existing repository, including the earlier unstaged Android stabilization and iOS removal. Nothing was reset, staged, committed or pushed. Existing Android memory/cross-drive fixes, Firebase client configuration, document processing, localization, routing and retained platform projects are preserved.

## Implemented behavior

- Removed Google Mobile Ads initialization, banner/native/interstitial/rewarded ads, ad loading/disposal callbacks, ad services and the AdProvider.
- Removed the ad-funded chat prompt counter/limit and its dialogs. Chat is no longer limited to three requests. Backend/service limits still apply.
- Summary generation/regeneration and quiz generation/regeneration call their existing operations directly, without waiting for an ad.
- Removed Apple authentication service, provider calls, button, callback interface and all five Apple sign-in localization keys/getters in every supported language. Sign-in descriptions now mention Google only.
- Google login loading, cancellation, success/error handling and Firebase logout/state persistence code remain. Email/password login, registration and reset were not implemented before this refactor and were not added.
- Added a shared Material 3 theme and navy/blue palette. Existing screen layouts are retained, except removal of ad space and prompt-gate UI.

## Theme

| Role | Color |
| --- | --- |
| Primary navy | #12345A |
| Blue accent | #2563EB |
| Tinted background | #F3F7FC |
| Soft blue surface | #E8F0FC |
| Border | #D6E2F0 |
| Body text | #172B4D |
| Secondary text | #526581 |

AppTheme configures Material 3 colors, typography, app bars, buttons, cards, dialogs, inputs, progress indicators, dividers and snackbars. Shared widgets and hardcoded screen colors now use the palette. Branding updates cover splash, welcome text, upload/recent-file cards, file header, chat bubbles/composer, summary, quiz/results/progress, navigation, sign-in and language selection. Correct/incorrect answer and error colors retain their semantic meaning.

The app previously supplied only a light ThemeData with no darkTheme or theme-mode preference. This refactor preserves that light-only behavior; it does not claim to add a complete dark mode. Existing native Android night resources are preserved.

## File changes in this refactor

### Deleted

- `lib/utils/ads_manager.dart`: all ad service implementations and identifiers.
- `lib/providers/ad_provider.dart`: ad state, counters, prompt rewards and limits.
- `lib/Auth/apple_auth.dart`: Firebase Apple provider implementation.

### Added

- `lib/utils/app_theme.dart`: shared Material 3 component theme.
- `test/ad_free_features_test.dart`: contrast/localization, chat beyond three requests, direct summary generation/regeneration tests.
- `docs/AD_FREE_THEME_REFACTOR.md`: this record.

### Configuration and entry point

- `pubspec.yaml`: remove google_mobile_ads; no new package.
- `pubspec.lock`: resolver removes google_mobile_ads and four otherwise-unused webview_flutter packages; no upgrades. The three sign_in_with_apple entries were already removed by the earlier task.
- `lib/main.dart`: remove ads initialization/provider/imports and use AppTheme.light.
- `android/app/src/main/AndroidManifest.xml`: remove AdMob application metadata; keep INTERNET for Firebase/AI.
- `android/app/src/main/res/values/styles.xml` and `android/app/src/main/res/values-night/styles.xml`: remove native-ad-only AppCompat theme requirement; use original Android normal theme parents.
- `macos/Flutter/GeneratedPluginRegistrant.swift`: pub get removes WebView registration no longer needed after ad removal. Other native plugins remain. This file also contains earlier task changes.
- `README.md`: current ad-free, Google-only and theme summary; remove obsolete Apple/production-ad setup statements.
- `docs/ANDROID_MIGRATION_REPORT.md` and `docs/FILE_BY_FILE_GIT_GUIDE.md`: add historical-record notices pointing here. Their older ads/Apple descriptions are preserved as history, not current setup guidance.

The iOS platform project was already removed by the prior task. No iOS runner plist, ad metadata or Apple entitlements remain in the active project. The remaining macOS entitlements contain sandbox/JIT/network settings, not Apple Sign-In capabilities. Firebase Apple-platform options and ordinary macOS/web Apple OS metadata are retained because they are unrelated to Apple authentication. Local generated iOS leftovers are ignored and were not deleted; pub get updated their plugin registrant without ad/Apple imports.

### Authentication, text and tests

- `lib/screens/signin_screen.dart`: Google-only dialog and callback interface; preserve safe asynchronous login behavior; blue styling.
- `lib/app_localization.dart`: remove Apple-specific map keys/getters and update all seven translated descriptions.
- `test/signin_dialog_test.dart`: adapt the dialog interface and provider-exception test to Google; retain missing AI configuration coverage.

### Ad removal and screen styling

- `lib/screens/chat/chat_screen.dart`: remove prompt counter/reward header and ad loading; retain chat UI/typing state; blue background.
- `lib/screens/chat/widgets/chat_message_handler.dart`: remove prompt gates/rewards/interstitial callbacks and stale commented ad implementation; capture localized error text before awaits.
- `lib/screens/chat/widgets/chat_content.dart`: palette update and remove stale commented implementation.
- `lib/screens/home/home_screen.dart`: remove native ad state/rendering/disposal and ad spacing; blue background gradient.
- `lib/screens/home/widgets/home_content.dart`: remove banner state/layout/disposal and keep content as a stateless widget.
- `lib/screens/home/widgets/recent_files_section.dart`, `upload_section.dart`, `welcome_section.dart`: palette and text contrast updates.
- `lib/screens/quiz/quiz_screen.dart`: remove preload and rewarded callbacks; direct generation/regeneration and palette update.
- `lib/screens/quiz/widgets/mcq_widget.dart`, `quiz_progress.dart`, `results_banner.dart`: blue accents and surfaces, retaining semantic grading colors.
- `lib/screens/summary/summary_screen.dart`: remove ad preload and use blue background.
- `lib/screens/summary/widgets/summary_empty.dart`, `summary_action_buttons.dart`: direct summary operations.
- `lib/screens/summary/widgets/key_findings_section.dart`, `main_topics_section.dart`, `summary_section.dart`: rename the shared purple surface reference to the blue surface token.
- `lib/screens/splash/splash_screen.dart`: navy/blue gradient and shared palette.
- `lib/utils/constants.dart`: blue palette; remove purple token name and unused gray alias.
- `lib/widgets/app_bar.dart`, `bottom_nav.dart`, `file_header.dart`, `language_switcher.dart`: shared blue tokens.

All other pending Git modifications from the earlier task remain separate pre-existing work for this request. No broad staging command was run.

## Verification

| Command/check | Result |
| --- | --- |
| `flutter pub get` | Passed, exit 0. Five packages removed; no upgrades or added packages. |
| `dart format lib/main.dart lib/utils/constants.dart lib/utils/app_theme.dart lib/app_localization.dart lib/screens lib/widgets test` | Passed, exit 0; 37 files checked, 14 formatted. Follow-up format included the new regression test and final palette cleanup. Executed with the installed SDK dart.exe. |
| `flutter analyze` | Exit 1 due to 35 existing informational lints; no errors or warnings. Earlier stable result was 36 infos. No lint suppression added. |
| `flutter test` | Passed, exit 0; seven tests. Fake callbacks/no API key are used, so this does not prove real provider login or external AI service success. |
| Source/platform scan | No active AdManager, AdProvider, google_mobile_ads, ad identifiers/reward callbacks or Apple-authentication symbols remain in lib, platform sources or dependencies. Historical docs and negative test assertions are not application implementations. |
| `git diff --check` | Passed; LF/CRLF notices are pre-existing Git conversion warnings. |
| `flutter build apk --debug` | Final result recorded below. |
| Final Android merged manifest | Checked after the successful build; result recorded below. Older generated manifests were not treated as current evidence. |

The tests verify Google login pending/success/error behavior, missing AI setup messaging, direct summary actions, more than three chat requests without a prompt gate, seven Google-only localized descriptions, and minimum 4.5:1 contrast for white text on both primary/secondary brand colors.

Existing informational findings include deprecated opacity API calls, print calls, naming and async-context diagnostics in quiz generation. They were not expanded into an unrelated cleanup. Real authentication and Gemini responses still need the owner's Firebase OAuth/provider configuration and API key. No phone installation, manual UI interaction or native macOS/Windows/Linux validation is claimed for this refactor.

## Final Android verification

`flutter build apk --debug` passed (exit 0, 193.3 seconds). Output: `build/app/outputs/flutter-apk/app-debug.apk`.

The freshly generated `build/app/intermediates/merged_manifests/debug/processDebugManifest/AndroidManifest.xml` was inspected after regeneration: zero matches for AD_ID, ACCESS_ADSERVICES, com.google.android.gms.ads, MobileAdsInitProvider or AdActivity. INTERNET remains for Firebase and AI. An older generated manifest seen during the build still contained ads; its old timestamp was recognized, and only the new merged manifest is used for the final result.

The final source/dependency scan found no ads/Apple-authentication implementation or configuration symbols. `google_sign_in_ios` remains because Google Sign-In on macOS still needs it; ordinary Apple OS names/metadata are unrelated to the removed provider. No signing or Firebase credentials were changed. The APK was built but was not deployed during this refactor; earlier phone observations in the historical report apply to the earlier build.

All seven tests passed. Default analysis retains 35 pre-existing informational findings and exits 1; this is not reported as a clean default analyzer pass. There are no introduced errors or warnings. Final whitespace check passed. No files were staged, committed or pushed.

