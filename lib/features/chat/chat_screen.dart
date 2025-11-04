import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/providers/pdf_provider.dart';
import 'package:docusense_ai/utils/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

// Import chat widgets
import 'widgets/chat_content.dart';

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
      body: SafeArea(
        child: ChatContent(
          chatController: _chatController,
          botUser: botUser,
          onMessageSend: _handleMessageSend,
        ),
      ),
    );
  }
}
