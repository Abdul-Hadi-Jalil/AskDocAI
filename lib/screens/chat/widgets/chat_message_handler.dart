import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/providers/pdf_provider.dart';
import 'package:docusense_ai/utils/gemini_service.dart';
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
    final pdfProvider = context.read<PdfProvider>();

    // Add user message
    _addUserMessage(text);

    // Get AI response
    try {
      final response = await getGeminiResponse(
        text,
        fileContent: pdfProvider.uploadedFileContent,
        fileName: pdfProvider.uploadedFileName,
      );

      _addBotMessage(response);
    } catch (e) {
      _addBotMessage(AppLocalizations.of(context).errorTryAgain);
    }
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
