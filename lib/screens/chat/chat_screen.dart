import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/screens/chat/widgets/chat_content.dart';
import 'package:docusense_ai/providers/pdf_provider.dart';
import 'package:docusense_ai/utils/gemini_service.dart';
import 'package:docusense_ai/widgets/app_bar.dart';
import 'package:docusense_ai/widgets/file_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:docusense_ai/utils/ads_manager.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatController = InMemoryChatController();
  final uuid = const Uuid();
  final User botUser = User(id: 'bot', name: 'DocuBot');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addWelcomeMessage();
    });

    AdManager.loadRewardedAd();
  }

  void _addWelcomeMessage() {
    final pdfProvider = context.read<PdfProvider>();
    final fileName = pdfProvider.uploadedFileName ?? 'your document';

    _chatController.insertMessage(
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

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  Future<void> _handleMessageSend(String text) async {
    final pdfProvider = context.read<PdfProvider>();

    // Add user message
    _chatController.insertMessage(
      TextMessage(
        id: uuid.v4(),
        authorId: 'user_1',
        text: text,
        createdAt: DateTime.now(),
      ),
    );

    // Get AI response
    try {
      final response = await getGeminiResponse(
        text,
        fileContent: pdfProvider.uploadedFileContent,
        fileName: pdfProvider.uploadedFileName,
      );

      _chatController.insertMessage(
        TextMessage(
          id: uuid.v4(),
          authorId: botUser.id,
          text: response,
          createdAt: DateTime.now(),
        ),
      );
    } catch (e) {
      _chatController.insertMessage(
        TextMessage(
          id: uuid.v4(),
          authorId: botUser.id,
          text: AppLocalizations.of(context).errorTryAgain,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(), // ← Add this line
      body: Column(
        children: [
          const FileHeader(showInfoButton: true), // ← Add this line
          Expanded(
            child: ChatContent(
              chatController: _chatController,
              botUser: botUser,
              onMessageSend: _handleMessageSend,
            ),
          ),
        ],
      ),
    );
  }
}
