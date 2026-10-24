import 'package:askdocai/utils/constants.dart';
import 'package:askdocai/screens/chat/widgets/chat_content.dart';
import 'package:askdocai/screens/chat/widgets/chat_message_handler.dart';
import 'package:askdocai/widgets/file_header.dart';
import 'package:askdocai/providers/auth_state.dart';
import 'package:askdocai/providers/pdf_provider.dart';
import 'package:askdocai/services/chat_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatController = InMemoryChatController();
  final uuid = const Uuid();
  final User botUser = User(id: 'bot', name: 'DocuBot');
  late ChatMessageHandler _messageHandler;

  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthState>().user?.uid;
    final pdf = context.read<PdfProvider>();
    _messageHandler = ChatMessageHandler(
      chatController: _chatController,
      uuid: uuid,
      botUser: botUser,
      store: userId == null
          ? null
          : FirestoreChatStore(
              userId: userId,
              documentName: pdf.uploadedFileName ?? 'document',
              documentContent: pdf.uploadedFileContent ?? '',
            ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _messageHandler.loadHistory();
      if (mounted && _chatController.messages.isEmpty) {
        _messageHandler.addWelcomeMessage(context);
      }
    });
  }

  Future<void> _handleMessageSend(String text) async {
    await _messageHandler.handleUserMessage(text: text, context: context);
  }

  @override
  void dispose() {
    _chatController.dispose();
    _messageHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _messageHandler,
      child: Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: Column(
          children: [
            const FileHeader(showInfoButton: true),
            Expanded(
              child: Consumer<ChatMessageHandler>(
                builder: (context, handler, child) {
                  return Column(
                    children: [
                      if (handler.isLoadingHistory)
                        const LinearProgressIndicator(),
                      if (handler.hasPersistenceError)
                        MaterialBanner(
                          content: const Text(
                            'Chat history could not sync. Check your connection and retry.',
                          ),
                          actions: [
                            TextButton(
                              onPressed:
                                  handler.isSaving || handler.isLoadingHistory
                                  ? null
                                  : handler.retryPersistence,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      Expanded(
                        child: IgnorePointer(
                          ignoring: handler.isLoadingHistory,
                          child: ChatContent(
                            chatController: _chatController,
                            botUser: botUser,
                            onMessageSend: _handleMessageSend,
                            isTyping: handler.isTyping,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
