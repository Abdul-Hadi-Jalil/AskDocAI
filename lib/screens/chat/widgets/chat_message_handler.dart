import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/providers/pdf_provider.dart';
import 'package:docusense_ai/utils/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class ChatMessageHandler extends ChangeNotifier {
  final ChatController chatController;
  final Uuid uuid;
  final User botUser;
  bool _isTyping = false;

  bool get isTyping => _isTyping;

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
    final pdfProvider = context.read<PdfProvider>();

    final errorMessage = AppLocalizations.of(context).errorTryAgain;

    // Add user message
    _addUserMessage(text);

    // Show typing indicator
    _setTyping(true);

    // Get AI response
    try {
      debugPrint("🎁 Sending message to Gemini");
      final response = await getGeminiResponse(
        text,
        fileContent: pdfProvider.uploadedFileContent,
        fileName: pdfProvider.uploadedFileName,
      );

      // Hide typing indicator
      _setTyping(false);

      // Add bot response
      _addBotMessage(response);
    } catch (e) {
      debugPrint("🎁 Error from Gemini: $e");
      _setTyping(false);
      _addBotMessage(errorMessage);
    }
  }

  void _setTyping(bool value) {
    _isTyping = value;
    notifyListeners();
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
