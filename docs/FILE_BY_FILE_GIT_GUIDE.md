> Historical record of the earlier Android migration. Ads and Apple authentication described here were subsequently removed. See [the current refactor report](AD_FREE_THEME_REFACTOR.md) for the current implementation and verification. Older staging instructions are not a current complete change inventory.

# File-by-file Git staging guide

Prepared 24 October 2026. No staging, commits, pushes, resets or stashes were performed.
Review `git diff -- <path>` before staging. Deleted tracked files use `git add -u -- <path>` to stage exactly that deletion. Root `/ios/` ignores preserved local generated leftovers; it does not prevent staging deletions of already tracked files.

The initial seven modified plugin files belong to existing work. Six have no semantic diff and are excluded below. The macOS registrant includes this task's dependency removal: use `git add -p` and inspect hunks. Do not stage unrelated pre-existing changes.

## Android stabilization

### `android/app/src/main/res/values/styles.xml`

- Type: modified.
- Change/reason: use `Theme.AppCompat.Light.NoActionBar` for NormalTheme after a native-ad AppCompatButton theme warning was observed on the phone.
- Impact: keeps a light theme without an action bar; Flutter launch theme is preserved.
- Individual staging command: `git add -- android/app/src/main/res/values/styles.xml`.
- Suggested commit message: `fix(android): provide AppCompat theme for native ads`.
- Dependencies: include with the matching night theme and native ad template fix.
- Validation: debug APK rebuild and phone relaunch; see migration report.

### `android/app/src/main/res/values-night/styles.xml`

- Type: modified.
- Change/reason: use `Theme.AppCompat.NoActionBar` for night NormalTheme to satisfy native ad AppCompat widgets in dark mode too.
- Impact: retains a dark theme without an action bar; shared Flutter UI unchanged.
- Individual staging command: `git add -- android/app/src/main/res/values-night/styles.xml`.
- Suggested commit message: `fix(android): align night theme with native ad widgets`.
- Dependencies: commit with the light theme. Device dark-mode behavior was not toggled or claimed tested.
- Validation: resource compilation; see final report for launch evidence.

### `android/gradle.properties`

- Type: modified.
- Change: disable Kotlin incremental compilation, lower Gradle heap to 2 GB/metaspace to 1 GB/code cache to 256 MB, cap workers at two and compile Kotlin in process.
- Reason: actual cross-drive cache errors and a JVM native-memory crash with the original 8 GB heap/4 GB metaspace settings on an 8 GB host.
- Impact: slower but less memory-intensive compilation; runtime and pinned toolchain versions are unchanged.
- Individual staging command: `git add -- android/gradle.properties`.
- Suggested commit message: `fix(android): avoid cross-drive Kotlin incremental cache failures`.
- Dependencies: include in the Android stabilization commit and validate with a fresh build invocation after this property is read.
- Validation: see the final Android build results in the migration report.

### `android/.gitignore`

- Type: modified.
- Change/reason: ignore `/.kotlin/` compiler session/cache artifacts observed as untracked during validation.
- Impact: local generated files remain on disk and are excluded from accidental staging.
- Individual staging command: `git add -- android/.gitignore`.
- Suggested commit message: `chore(android): ignore Kotlin compiler session artifacts`.
- Dependencies: include with Android stabilization; no runtime dependency.
- Validation: final Git status and ignore checks.

Suggested logical commit: `fix(android): stabilize startup, ads and document state`.

Ordering: review all related hunks before committing. Dependency removal, AppleAuthProvider replacement, macOS registrant update and iOS Firebase/metadata changes should land together (or in one combined stabilization commit) to avoid intermediate broken states. Tests depend on the new sign-in dialog. Documentation should reflect the final implementation and results.

### `android/app/src/main/AndroidManifest.xml`

- Type: modified.
- Change: Declare INTERNET in the main manifest.
- Reason: Firebase, AI and ads need networking outside debug/profile builds.
- Impact: Release variants gain required network access; no cleartext allowance added.
- Individual staging command: `git add -- "android/app/src/main/AndroidManifest.xml"`.
- Suggested commit message: `fix(android): Declare INTERNET in the main manifest.`.
- Validation: Manifest inspection; Android build attempted.
- Ordering: follow group dependencies above.

### `lib/main.dart`

- Type: modified.
- Change: Initialize ads only on Android; load dotenv optionally; retain PdfProvider across file updates and create providers with the shared FileProvider.
- Reason: Prevent unsupported-platform startup calls, missing-config startup failures and provider state replacement during file processing.
- Impact: Existing routes, languages, Firebase and UI remain.
- Individual staging command: `git add -- "lib/main.dart"`.
- Suggested commit message: `fix(android): Initialize ads only on Android`.
- Validation: Static analysis, tests and target build attempts.
- Ordering: follow group dependencies above.

### `lib/screens/home/home_screen.dart`

- Type: modified.
- Change: Render native ad only after load; dispose and clear failed ads.
- Reason: Prevent missing-template startup crash and premature native ad rendering.
- Impact: Home content still works if an ad is unavailable.
- Individual staging command: `git add -- "lib/screens/home/home_screen.dart"`.
- Suggested commit message: `fix(android): Render native ad only after load`.
- Validation: Static analysis, successful debug APK builds and physical-phone startup/native test-ad rendering; injected interaction denied.
- Ordering: follow group dependencies above.

### `lib/screens/splash/splash_screen.dart`

- Type: modified.
- Change: Cancel progress timer and check mounted before timer updates/navigation.
- Reason: Prevent delayed callbacks accessing disposed splash state.
- Impact: Same splash timing and navigation behavior.
- Individual staging command: `git add -- "lib/screens/splash/splash_screen.dart"`.
- Suggested commit message: `fix(android): Cancel progress timer and check mounted before timer updates/navigation.`.
- Validation: Static analysis and lifecycle inspection.
- Ordering: follow group dependencies above.

### `lib/utils/ads_manager.dart`

- Type: modified.
- Change: Guard ad creation/loading to Android; add native small template and use a test interstitial unit of the correct format.
- Reason: Fix invalid native ad construction and banner-unit misuse for interstitials.
- Impact: Interstitial remains test-only until owner supplies production unit; desktop/web ads omitted.
- Individual staging command: `git add -- "lib/utils/ads_manager.dart"`.
- Suggested commit message: `fix(android): Guard ad creation/loading to Android`.
- Validation: Installed plugin source and official templates documentation inspected; static analysis.
- Ordering: follow group dependencies above.

### `lib/utils/file_helper.dart`

- Type: modified.
- Change: Request selected-file bytes and decode Markdown like plain text.
- Reason: Picker did not request bytes for text and accepted Markdown without reading it.
- Impact: More memory used for selected binary documents; extraction paths retained.
- Individual staging command: `git add -- "lib/utils/file_helper.dart"`.
- Suggested commit message: `fix(android): Request selected-file bytes and decode Markdown like plain text.`.
- Validation: Static analysis; physical file picker not yet verified.
- Ordering: follow group dependencies above.

### `lib/utils/gemini_service.dart`

- Type: modified.
- Change: Read API_KEY from Dart defines with legacy dotenv fallback; return explicit setup message when missing.
- Reason: Remove fabricated fallback API key and misleading service-demand message for absent configuration.
- Impact: AI still requires valid external key; existing prompts/model unchanged.
- Individual staging command: `git add -- "lib/utils/gemini_service.dart"`.
- Suggested commit message: `fix(android): Read API_KEY from Dart defines with legacy dotenv fallback`.
- Validation: Static analysis; external Gemini requests untested.
- Ordering: follow group dependencies above.

## Firebase and authentication fixes

Suggested logical commit: `fix(auth): await provider login and synchronize logout`.

Ordering: review all related hunks before committing. Dependency removal, AppleAuthProvider replacement, macOS registrant update and iOS Firebase/metadata changes should land together (or in one combined stabilization commit) to avoid intermediate broken states. Tests depend on the new sign-in dialog. Documentation should reflect the final implementation and results.

### `lib/Auth/apple_auth.dart`

- Type: modified.
- Change: Use Firebase AppleAuthProvider popup/native provider flows instead of iOS-oriented credential plugin.
- Reason: Retain Apple authentication after removing iOS-specific implementation.
- Impact: Apple provider console setup remains required; no live login claimed.
- Individual staging command: `git add -- "lib/Auth/apple_auth.dart"`.
- Suggested commit message: `fix(auth): Use Firebase AppleAuthProvider popup/native provider flows instead of iOS-oriented credential plugin.`.
- Validation: Analysis and dialog regression tests; API checked in installed Firebase source.
- Ordering: follow group dependencies above.

### `lib/Auth/google_auth.dart`

- Type: modified.
- Change: Use Firebase popup on web and provider flow on Windows; retain native Google plugin elsewhere.
- Reason: Avoid invoking unsupported Google plugin implementations on retained targets.
- Impact: Actual account login still requires OAuth setup.
- Individual staging command: `git add -- "lib/Auth/google_auth.dart"`.
- Suggested commit message: `fix(auth): Use Firebase popup on web and provider flow on Windows`.
- Validation: Static analysis; no credentialed login.
- Ordering: follow group dependencies above.

### `lib/Auth/google_sign_out.dart`

- Type: modified.
- Change: Capture providers before awaits, await Firebase logout, clear document selection/summary and guard Google session cleanup by platform.
- Reason: Avoid stale dialog-context access and inconsistent local logout state.
- Impact: Firebase auth stream remains authoritative; recent-file list preserved.
- Individual staging command: `git add -- "lib/Auth/google_sign_out.dart"`.
- Suggested commit message: `fix(auth): Capture providers before awaits, await Firebase logout, clear document selection/summary and guard Google session cleanup by platform.`.
- Validation: Static analysis and call-site inspection; live logout untested.
- Ordering: follow group dependencies above.

### `lib/providers/auth_state.dart`

- Type: modified.
- Change: Store and cancel the auth state stream subscription on disposal.
- Reason: Prevent notifications from outliving the provider.
- Impact: Firebase persistence and auth state stream unchanged.
- Individual staging command: `git add -- "lib/providers/auth_state.dart"`.
- Suggested commit message: `fix(auth): Store and cancel the auth state stream subscription on disposal.`.
- Validation: Static analysis and lifecycle inspection.
- Ordering: follow group dependencies above.

### `lib/screens/signin_screen.dart`

- Type: modified.
- Change: Keep dialog mounted during provider login, disable duplicate/cancel actions while busy, return true only after success and present retryable errors.
- Reason: Old dialog returned success before login and reused its disposed context.
- Impact: Google and Apple buttons retained; explicit Cancel remains available.
- Individual staging command: `git add -- "lib/screens/signin_screen.dart"`.
- Suggested commit message: `fix(auth): Keep dialog mounted during provider login, disable duplicate/cancel actions while busy, return true only after success and present retryable errors.`.
- Validation: Three widget regression tests passed.
- Ordering: follow group dependencies above.

### `lib/widgets/app_bar.dart`

- Type: modified.
- Change: Separate parent/dialog context and await logout with visible failure feedback.
- Reason: Avoid optimistic local logout and stale context after confirmation closes.
- Impact: Sign-in/out actions and language selector retained.
- Individual staging command: `git add -- "lib/widgets/app_bar.dart"`.
- Suggested commit message: `fix(auth): Separate parent/dialog context and await logout with visible failure feedback.`.
- Validation: Static analysis and call-site review.
- Ordering: follow group dependencies above.

## iOS platform removal

Suggested logical commit: `chore(platforms): remove iOS project and adapt Apple authentication`.

Ordering: review all related hunks before committing. Dependency removal, AppleAuthProvider replacement, macOS registrant update and iOS Firebase/metadata changes should land together (or in one combined stabilization commit) to avoid intermediate broken states. Tests depend on the new sign-in dialog. Documentation should reflect the final implementation and results.

### `.gitignore`

- Type: modified.
- Change: Keep local iOS leftovers and config.local.json ignored; replace obsolete iOS build-id rule.
- Reason: Preserve local files and prevent credentials or removed platform caches being added.
- Impact: Local-only files remain on disk.
- Individual staging command: `git add -- ".gitignore"`.
- Suggested commit message: `chore(platforms): Keep local iOS leftovers and config.local.json ignored`.
- Validation: Git ignore/status review.
- Ordering: follow group dependencies above.

### `.metadata`

- Type: modified.
- Change: Remove iOS migration entry and unmanaged Xcode-project path.
- Reason: Flutter metadata must match retained targets.
- Impact: Other platform metadata is retained.
- Individual staging command: `git add -- ".metadata"`.
- Suggested commit message: `chore(platforms): Remove iOS migration entry and unmanaged Xcode-project path.`.
- Validation: Diff inspection.
- Ordering: follow group dependencies above.

### `firebase.json`

- Type: modified.
- Change: Remove only the iOS FlutterFire configuration mapping.
- Reason: Stop maintaining an iOS Firebase target.
- Impact: Android and macOS mappings retained.
- Individual staging command: `git add -- "firebase.json"`.
- Suggested commit message: `chore(platforms): Remove only the iOS FlutterFire configuration mapping.`.
- Validation: JSON parsing and diff inspection.
- Ordering: follow group dependencies above.

### `ios/.gitignore`

- Type: deleted.
- Change: Remove iOS native runner configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/.gitignore"`.
- Suggested commit message: `chore(ios): remove ios/.gitignore`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Flutter/AppFrameworkInfo.plist`

- Type: deleted.
- Change: Remove iOS Flutter build settings.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Flutter/AppFrameworkInfo.plist"`.
- Suggested commit message: `chore(ios): remove ios/Flutter/AppFrameworkInfo.plist`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Flutter/Debug.xcconfig`

- Type: deleted.
- Change: Remove iOS Flutter build settings.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Flutter/Debug.xcconfig"`.
- Suggested commit message: `chore(ios): remove ios/Flutter/Debug.xcconfig`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Flutter/Release.xcconfig`

- Type: deleted.
- Change: Remove iOS Flutter build settings.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Flutter/Release.xcconfig"`.
- Suggested commit message: `chore(ios): remove ios/Flutter/Release.xcconfig`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Podfile`

- Type: deleted.
- Change: Remove iOS CocoaPods dependency configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Podfile"`.
- Suggested commit message: `chore(ios): remove ios/Podfile`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Podfile.lock`

- Type: deleted.
- Change: Remove iOS CocoaPods dependency configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Podfile.lock"`.
- Suggested commit message: `chore(ios): remove ios/Podfile.lock`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner.xcodeproj/project.pbxproj`

- Type: deleted.
- Change: Remove Xcode project/workspace configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner.xcodeproj/project.pbxproj"`.
- Suggested commit message: `chore(ios): remove ios/Runner.xcodeproj/project.pbxproj`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner.xcodeproj/project.xcworkspace/contents.xcworkspacedata`

- Type: deleted.
- Change: Remove Xcode project/workspace configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner.xcodeproj/project.xcworkspace/contents.xcworkspacedata"`.
- Suggested commit message: `chore(ios): remove ios/Runner.xcodeproj/project.xcworkspace/contents.xcworkspacedata`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist`

- Type: deleted.
- Change: Remove Xcode project/workspace configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist"`.
- Suggested commit message: `chore(ios): remove ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings`

- Type: deleted.
- Change: Remove Xcode project/workspace configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings"`.
- Suggested commit message: `chore(ios): remove ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme`

- Type: deleted.
- Change: Remove Xcode project/workspace configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme"`.
- Suggested commit message: `chore(ios): remove ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner.xcworkspace/contents.xcworkspacedata`

- Type: deleted.
- Change: Remove iOS native runner configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner.xcworkspace/contents.xcworkspacedata"`.
- Suggested commit message: `chore(ios): remove ios/Runner.xcworkspace/contents.xcworkspacedata`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist`

- Type: deleted.
- Change: Remove iOS native runner configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist"`.
- Suggested commit message: `chore(ios): remove ios/Runner.xcworkspace/xcshareddata/IDEWorkspaceChecks.plist`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings`

- Type: deleted.
- Change: Remove iOS native runner configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings"`.
- Suggested commit message: `chore(ios): remove ios/Runner.xcworkspace/xcshareddata/WorkspaceSettings.xcsettings`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/AppDelegate.swift`

- Type: deleted.
- Change: Remove iOS native runner configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/AppDelegate.swift"`.
- Suggested commit message: `chore(ios): remove ios/Runner/AppDelegate.swift`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/LaunchImage.imageset/Contents.json`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@2x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/LaunchImage.imageset/LaunchImage@3x.png`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md`

- Type: deleted.
- Change: Remove iOS-only icon/launch asset.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Assets.xcassets/LaunchImage.imageset/README.md`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Base.lproj/LaunchScreen.storyboard`

- Type: deleted.
- Change: Remove iOS native runner configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Base.lproj/LaunchScreen.storyboard"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Base.lproj/LaunchScreen.storyboard`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Base.lproj/Main.storyboard`

- Type: deleted.
- Change: Remove iOS native runner configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Base.lproj/Main.storyboard"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Base.lproj/Main.storyboard`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/GoogleService-Info.plist`

- Type: deleted.
- Change: Remove iOS Firebase plist.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/GoogleService-Info.plist"`.
- Suggested commit message: `chore(ios): remove ios/Runner/GoogleService-Info.plist`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Info.plist`

- Type: deleted.
- Change: Remove iOS native runner configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Info.plist"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Info.plist`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Runner-Bridging-Header.h`

- Type: deleted.
- Change: Remove iOS native runner configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Runner-Bridging-Header.h"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Runner-Bridging-Header.h`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/Runner/Runner.entitlements`

- Type: deleted.
- Change: Remove iOS native runner configuration.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/Runner/Runner.entitlements"`.
- Suggested commit message: `chore(ios): remove ios/Runner/Runner.entitlements`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `ios/RunnerTests/RunnerTests.swift`

- Type: deleted.
- Change: Remove iOS native test.
- Reason: Remove the requested iOS project support.
- Impact: Affects iOS only; shared assets and retained platform files untouched.
- Individual staging command: `git add -u -- "ios/RunnerTests/RunnerTests.swift"`.
- Suggested commit message: `chore(ios): remove ios/RunnerTests/RunnerTests.swift`.
- Validation: Tracked-path inventory and final deletion review.
- Ordering: follow group dependencies above.

### `lib/firebase_options.dart`

- Type: modified.
- Change: Delete iOS options and explicitly reject iOS initialization.
- Reason: Remove iOS-only Firebase configuration.
- Impact: macOS Firebase app ID and iosBundleId are necessary Apple-platform fields and retained.
- Individual staging command: `git add -- "lib/firebase_options.dart"`.
- Suggested commit message: `chore(platforms): Delete iOS options and explicitly reject iOS initialization.`.
- Validation: Static analysis and diff inspection.
- Ordering: follow group dependencies above.

### `macos/Flutter/GeneratedPluginRegistrant.swift`

- Type: modified.
- Change: Flutter regeneration removes sign_in_with_apple import/registration.
- Reason: Dependency now replaced by Firebase provider API.
- Impact: Pre-existing modified file: selectively stage task hunks only; all other registrations preserved.
- Individual staging command: `git add -p -- "macos/Flutter/GeneratedPluginRegistrant.swift"`.
- Suggested commit message: `chore(platforms): Flutter regeneration removes sign_in_with_apple import/registration.`.
- Validation: Generated diff inspection.
- Ordering: follow group dependencies above.

### `pubspec.lock`

- Type: modified.
- Change: Remove only three sign_in_with_apple package entries.
- Reason: Keep lockfile synchronized with focused dependency removal.
- Impact: Other pinned dependency versions unchanged.
- Individual staging command: `git add -- "pubspec.lock"`.
- Suggested commit message: `chore(platforms): Remove only three sign_in_with_apple package entries.`.
- Validation: flutter pub get succeeded.
- Ordering: follow group dependencies above.

### `pubspec.yaml`

- Type: modified.
- Change: Remove sign_in_with_apple and mandatory .env asset; remove obsolete iOS version comments.
- Reason: Stop iOS credential plugin dependency and missing .env build failure.
- Impact: Legacy .env can be explicitly registered locally; prefer Dart define JSON. Shared Cupertino dependency retained.
- Individual staging command: `git add -- "pubspec.yaml"`.
- Suggested commit message: `chore(platforms): Remove sign_in_with_apple and mandatory .env asset`.
- Validation: Dependency resolution, static analysis and tests.
- Ordering: follow group dependencies above.

## Documentation and validation

Suggested logical commit: `docs: record Android migration validation and staging guide`.

Ordering: review all related hunks before committing. Dependency removal, AppleAuthProvider replacement, macOS registrant update and iOS Firebase/metadata changes should land together (or in one combined stabilization commit) to avoid intermediate broken states. Tests depend on the new sign-in dialog. Documentation should reflect the final implementation and results.

### `README.md`

- Type: modified.
- Change: Replace starter text with actual Android and Firebase setup and report links.
- Reason: Make development and remaining setup reproducible.
- Impact: Documents optional AI configuration and existing platform limits.
- Individual staging command: `git add -- "README.md"`.
- Suggested commit message: `docs(test): Replace starter text with actual Android and Firebase setup and report links.`.
- Validation: Commands cross-checked against executed validation.
- Ordering: follow group dependencies above.

### `test/signin_dialog_test.dart`

- Type: added.
- Change: Add tests for pending authentication, retryable failure, Apple provider exception and missing AI configuration.
- Reason: Protect sign-in dialog lifecycle, success-return fixes and missing AI setup handling.
- Impact: Uses injected fake callbacks; does not prove real Firebase login.
- Individual staging command: `git add -- "test/signin_dialog_test.dart"`.
- Suggested commit message: `docs(test): Add tests for pending authentication, retryable failure, Apple provider exception and missing AI configuration.`.
- Validation: flutter test: four passed (including missing AI setup).
- Ordering: follow group dependencies above.

### `docs/ANDROID_MIGRATION_REPORT.md`

- Type: added.
- Change: Record baseline, environment, changes, validation, device evidence and outstanding setup.
- Reason: Provide a reproducible audit of this task.
- Impact: Documentation only.
- Individual staging command: `git add -- "docs/ANDROID_MIGRATION_REPORT.md"`.
- Suggested commit message: `docs(test): Record baseline, environment, changes, validation, device evidence and outstanding setup.`.
- Validation: Manual consistency review and git diff --check.
- Ordering: follow group dependencies above.

### `docs/FILE_BY_FILE_GIT_GUIDE.md`

- Type: added.
- Change: Document each individual staging command, commit suggestion and ordering.
- Reason: Allow deliberate per-file review without automatic staging.
- Impact: Documentation only; commands are suggestions and have not been executed.
- Individual staging command: `git add -- "docs/FILE_BY_FILE_GIT_GUIDE.md"`.
- Suggested commit message: `docs(test): Document each individual staging command, commit suggestion and ordering.`.
- Validation: Inventory compared with Git changes.
- Ordering: follow group dependencies above.


