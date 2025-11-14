import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdManager {
  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;

  // Ad Unit IDs for different screens
  static const String nativeAdUnitId = kReleaseMode
      ? 'ca-app-pub-3774337907915828/7524917203'
      : 'ca-app-pub-3940256099942544/2247696110';

  static const String rewardedChatAdUnitId = kReleaseMode
      ? 'ca-app-pub-3774337907915828/4104546947'
      : 'ca-app-pub-3940256099942544/5224354917';

  static const String rewardedQuizAdUnitId = kReleaseMode
      ? 'ca-app-pub-3774337907915828/9205379126'
      : 'ca-app-pub-3940256099942544/5224354917';

  static const String rewardedSummaryAdUnitId = kReleaseMode
      ? 'ca-app-pub-3774337907915828/5417628611'
      : 'ca-app-pub-3940256099942544/5224354917';

  static const String bannerAdUnitId = kReleaseMode
      ? 'ca-app-pub-3774337907915828/7524917203'
      : 'ca-app-pub-3940256099942544/6300978111';

  // ---------------------------------------------------------------------------
  // 🔹 Load Interstitial Ad
  // ---------------------------------------------------------------------------
  static Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId:
          bannerAdUnitId, // Using banner ID for interstitial as placeholder
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('✅ Interstitial Ad loaded.');
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('❌ Failed to load Interstitial Ad: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🔹 Show Interstitial Ad
  // ---------------------------------------------------------------------------
  static void showInterstitialAd({VoidCallback? onAdDismissed}) {
    if (_interstitialAd == null) {
      debugPrint('⚠️ Interstitial ad is not ready.');
      loadInterstitialAd();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('👋 Interstitial Ad dismissed.');
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
        if (onAdDismissed != null) onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('❌ Failed to show interstitial: $error');
        ad.dispose();
        _interstitialAd = null;
      },
    );

    _interstitialAd!.show();
  }

  // ---------------------------------------------------------------------------
  // 🔹 Load Rewarded Chat Ad
  // ---------------------------------------------------------------------------
  static Future<void> loadRewardedChatAd() async {
    await RewardedAd.load(
      adUnitId: rewardedChatAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('✅ Rewarded Chat Ad loaded.');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('❌ Failed to load Rewarded Chat Ad: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🔹 Load Rewarded Quiz Ad
  // ---------------------------------------------------------------------------
  static Future<void> loadRewardedQuizAd() async {
    await RewardedAd.load(
      adUnitId: rewardedQuizAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('✅ Rewarded Quiz Ad loaded.');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('❌ Failed to load Rewarded Quiz Ad: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🔹 Load Rewarded Summary Ad
  // ---------------------------------------------------------------------------
  static Future<void> loadRewardedSummaryAd() async {
    await RewardedAd.load(
      adUnitId: rewardedSummaryAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('✅ Rewarded Summary Ad loaded.');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('❌ Failed to load Rewarded Summary Ad: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🔹 Show Rewarded Ad
  // ---------------------------------------------------------------------------
  static void showRewardedAd({
    required Function(int rewardAmount) onUserEarnedReward,
    VoidCallback? onAdDismissed,
  }) {
    if (_rewardedAd == null) {
      debugPrint('⚠️ Rewarded ad not ready.');
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('👋 Rewarded Ad dismissed.');
        ad.dispose();
        _rewardedAd = null;
        if (onAdDismissed != null) onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('❌ Failed to show rewarded: $error');
        ad.dispose();
        _rewardedAd = null;
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        onUserEarnedReward(reward.amount.toInt());
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 🔹 Banner Ad Widget
  // ---------------------------------------------------------------------------
  static BannerAd createBannerAd() {
    return BannerAd(
      size: AdSize.banner,
      adUnitId: bannerAdUnitId,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )..load();
  }

  // ---------------------------------------------------------------------------
  // 🔹 Native Ad Widget
  // ---------------------------------------------------------------------------
  static NativeAd createNativeAd() {
    return NativeAd(
      adUnitId: nativeAdUnitId,
      request: const AdRequest(),
      listener: NativeAdListener(),
      nativeAdOptions: NativeAdOptions(
        adChoicesPlacement: AdChoicesPlacement.topRightCorner,
      ),
    )..load();
  }
}
