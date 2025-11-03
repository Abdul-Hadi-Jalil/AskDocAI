import 'package:docusense_ai/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import '../providers/pdf_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/file_header.dart'; // Import the new widget
import '../utils/gemini_service.dart';
import '../utils/constants.dart';

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
        child: Column(
          children: [
            // Custom App Bar
            const CustomAppBar(),

            // File Header - Using the new widget (no parameters needed)
            const FileHeader(),

            // Chat UI Section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Chat(
                  currentUserId: 'user_1',
                  chatController: _chatController,
                  theme: ChatTheme(
                    colors: ChatColors(
                      primary: AppConstants.primaryColor,
                      onPrimary: Colors.white,
                      surface: Colors.white,
                      onSurface: AppConstants.textColor,
                      surfaceContainer: AppConstants.lightPurple,
                      surfaceContainerLow: Colors.grey.shade100,
                      surfaceContainerHigh: Colors.grey.shade200,
                    ),
                    typography: ChatTypography(
                      bodyLarge: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: AppConstants.textColor,
                      ),
                      bodyMedium: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppConstants.textColor,
                      ),
                      bodySmall: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: AppConstants.subtitleColor,
                      ),
                      labelLarge: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textColor,
                      ),
                      labelMedium: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppConstants.textColor,
                      ),
                      labelSmall: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppConstants.subtitleColor,
                      ),
                    ),
                    shape: BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  resolveUser: (UserID id) async {
                    if (id == 'user_1') {
                      return User(id: id, name: 'You');
                    } else if (id == 'bot') {
                      return botUser;
                    } else {
                      return null;
                    }
                  },
                  onMessageSend: _handleMessageSend,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
