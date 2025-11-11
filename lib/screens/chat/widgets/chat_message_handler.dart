import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/providers/pdf_provider.dart';
import 'package:docusense_ai/providers/ad_provider.dart';
import 'package:docusense_ai/utils/gemini_service.dart';
import 'package:docusense_ai/utils/ads_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class ChatMessageHandler {
  final ChatController chatController;
  final Uuid uuid;
  final User botUser;

  ChatMessageHandler({
    required this.chatController,
    required this.uuid,
    required this.botUser,
  });

  void addWelcomeMessage(BuildContext context) {
    final pdfProvider = context.read<PdfProvider>();
    final fileName = pdfProvider.uploadedFileName ?? 'your document';

    chatController.insertMessage(
      TextMessage(
        id: uuid.v4(),
        authorId: botUser.id,
        text: AppLocalizations.of(
          context,
        ).chatWelcomeMessage.replaceAll('%fileName', fileName),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> handleUserMessage({
    required String text,
    required BuildContext context,
  }) async {
    final adProvider = context.read<AdProvider>();
    final pdfProvider = context.read<PdfProvider>();

    // Check if user has available prompts
    if (adProvider.availablePrompts <= 0) {
      showNoPromptsDialog(context);
      return;
    }

    // Use one prompt
    adProvider.usePrompt();

    // Add user message
    _addUserMessage(text);

    // Get AI response
    try {
      debugPrint("🎁 Sending message to Gemini");
      final response = await getGeminiResponse(
        text,
        fileContent: pdfProvider.uploadedFileContent,
        fileName: pdfProvider.uploadedFileName,
      );

      _addBotMessage(response);

      // Show interstitial ad after every 3 messages (optional)
      _checkAndShowInterstitialAd(adProvider);
    } catch (e) {
      debugPrint("🎁 Error from Gemini: $e");
      _addBotMessage(AppLocalizations.of(context).errorTryAgain);
    }
  }

  void _checkAndShowInterstitialAd(AdProvider adProvider) {
    // Show interstitial ad after every 3 messages
    if (adProvider.messageCount % 3 == 0) {
      AdManager.showInterstitialAd();
    }
    adProvider.incrementMessageCount();
  }

  void showNoPromptsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Prompts Available'),
        content: const Text(
          'Watch a short ad to get more prompts and continue chatting with your document.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              showRewardedAd(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[700],
            ),
            child: const Text(
              'Watch Ad',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void showRewardedAd(BuildContext context) {
    final adProvider = context.read<AdProvider>();
    adProvider.setAdLoading(true);

    AdManager.showRewardedAd(
      onUserEarnedReward: (int rewardAmount) {
        adProvider.addPrompts(1);
        adProvider.setAdLoading(false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '+${rewardAmount > 0 ? rewardAmount : 1} prompt${rewardAmount > 1 ? 's' : ''} added!',
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.green,
          ),
        );
      },
      onAdDismissed: () {
        // This is called when ad is dismissed regardless of reward
        if (!adProvider.isAdLoading) {
          adProvider.setAdLoading(false);
        }
      },
    );
  }

  void _addUserMessage(String text) {
    chatController.insertMessage(
      TextMessage(
        id: uuid.v4(),
        authorId: 'user_1',
        text: text,
        createdAt: DateTime.now(),
      ),
    );
  }

  void _addBotMessage(String text) {
    chatController.insertMessage(
      TextMessage(
        id: uuid.v4(),
        authorId: botUser.id,
        text: text,
        createdAt: DateTime.now(),
      ),
    );
  }
}
