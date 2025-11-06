import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdManager {
  static InterstitialAd? _interstitialAd;
  static RewardedAd? _rewardedAd;

  /// ✅ Replace with your real Ad Unit IDs
  static const String interstitialAdUnitId = kReleaseMode
      ? 'ca-app-pub-xxxxxxxxxxxxxxxx/interstitial'
      : 'ca-app-pub-3940256099942544/1033173712'; // test ID

  static const String rewardedAdUnitId = kReleaseMode
      ? 'ca-app-pub-xxxxxxxxxxxxxxxx/rewarded'
      : 'ca-app-pub-3940256099942544/5224354917'; // test ID

  // ---------------------------------------------------------------------------
  // 🔹 Load Interstitial Ad
  // ---------------------------------------------------------------------------
  static Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
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
        loadInterstitialAd(); // preload next
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
  // 🔹 Load Rewarded Ad
  // ---------------------------------------------------------------------------
  static Future<void> loadRewardedAd() async {
    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          debugPrint('✅ Rewarded Ad loaded.');
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('❌ Failed to load Rewarded Ad: $error');
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
      loadRewardedAd();
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('👋 Rewarded Ad dismissed.');
        ad.dispose();
        _rewardedAd = null;
        loadRewardedAd();
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
  // 🔹 Banner Ad Widget (Optional)
  // ---------------------------------------------------------------------------
  static BannerAd createBannerAd() {
    return BannerAd(
      size: AdSize.banner,
      adUnitId: kReleaseMode
          ? 'ca-app-pub-xxxxxxxxxxxxxxxx/banner'
          : 'ca-app-pub-3940256099942544/6300978111', // test ID
      listener: const BannerAdListener(),
      request: const AdRequest(),
    )..load();
  }
}
