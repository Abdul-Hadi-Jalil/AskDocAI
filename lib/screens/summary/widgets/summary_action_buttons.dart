import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/providers/summary_provider.dart';
import 'package:docusense_ai/utils/ads_manager.dart';
import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SummaryActionButtons extends StatelessWidget {
  const SummaryActionButtons({super.key});
  @override
  Widget build(BuildContext context) {
    final summaryProvider = Provider.of<SummaryProvider>(
      context,
      listen: false,
    );
    return Column(
      children: [
        OutlinedButton(
          onPressed: () async {
            try {
              // 1️⃣ Start generating summary in background
              final generateFuture = summaryProvider.generateSummary();

              AdManager.showRewardedAd(
                onUserEarnedReward: (reward) async {
                  debugPrint('🎁 User watched ad and earned reward: $reward');
                },
                onAdDismissed: () async {
                  debugPrint('👋 Ad closed — now showing summary');
                  await generateFuture;
                  // UI auto updates from provider
                },
              );
            } catch (e) {
              debugPrint('❌ Failed to show Interstitial Ad: $e');
            }
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: const BorderSide(color: AppConstants.primaryColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.refresh,
                color: AppConstants.primaryColor,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).regenerate,
                style: const TextStyle(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),
        //ElevatedButton(
        //  onPressed: () {},
        //  style: ElevatedButton.styleFrom(
        //    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        //    backgroundColor: AppConstants.primaryColor,
        //    shape: RoundedRectangleBorder(
        //      borderRadius: BorderRadius.circular(8),
        //    ),
        //    elevation: 4,
        //    shadowColor: AppConstants.primaryColor.withOpacity(0.3),
        //  ),
        //  child: Row(
        //    mainAxisAlignment: MainAxisAlignment.center,
        //    children: [
        //      const Icon(Icons.share, color: Colors.white, size: 16),
        //      const SizedBox(width: 8),
        //      Text(
        //        AppLocalizations.of(context).shareSummary,
        //        style: const TextStyle(
        //          color: Colors.white,
        //          fontWeight: FontWeight.w600,
        //        ),
        //      ),
        //    ],
        //  ),
        //),
      ],
    );
  }
}
