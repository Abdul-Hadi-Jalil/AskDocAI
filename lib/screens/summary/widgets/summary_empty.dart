import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/models/app_state.dart';
import 'package:docusense_ai/providers/file_provider.dart';
import 'package:docusense_ai/providers/pdf_provider.dart';
import 'package:docusense_ai/providers/summary_provider.dart';
import 'package:docusense_ai/utils/ads_manager.dart';
import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SummaryEmpty extends StatelessWidget {
  final FileProvider fileProvider;

  const SummaryEmpty({super.key, required this.fileProvider});

  @override
  Widget build(BuildContext context) {
    final summaryProvider = Provider.of<SummaryProvider>(
      context,
      listen: false,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.description_outlined,
              color: AppConstants.primaryColor,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              fileProvider.hasFile
                  ? AppLocalizations.of(context).generateSummary
                  : AppLocalizations.of(context).noDocumentUploaded,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppConstants.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              fileProvider.hasFile
                  ? AppLocalizations.of(context).tapToGenerateSummary
                  : AppLocalizations.of(context).uploadFirstForSummary,
              style: const TextStyle(
                color: AppConstants.subtitleColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (fileProvider.hasFile)
              ElevatedButton(
                onPressed: () async {
                  try {
                    // 1️⃣ Start generating summary in background
                    final generateFuture = summaryProvider.generateSummary();

                    // 2️⃣ Show Interstitial Ad
                    AdManager.showRewardedAd(
                      onUserEarnedReward: (reward) async {
                        debugPrint(
                          '🎁 User watched ad and earned reward: $reward',
                        );
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(AppLocalizations.of(context).generateSummary),
              )
            else
              ElevatedButton(
                onPressed: () => _navigateToHome(
                  context,
                ), // ✅ Correct: Pass function reference
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(AppLocalizations.of(context).uploadDocument),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    final pdfProvider = Provider.of<PdfProvider>(context, listen: false);
    pdfProvider.changeTab(BottomNavItem.home);
  }
}
