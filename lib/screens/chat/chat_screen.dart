import 'package:docusense_ai/utils/constants.dart';
import 'package:docusense_ai/screens/chat/widgets/chat_content.dart';
import 'package:docusense_ai/screens/chat/widgets/chat_message_handler.dart';
import 'package:docusense_ai/widgets/file_header.dart';
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
    _messageHandler = ChatMessageHandler(
      chatController: _chatController,
      uuid: uuid,
      botUser: botUser,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _messageHandler.addWelcomeMessage(context);
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
                  return ChatContent(
                    chatController: _chatController,
                    botUser: botUser,
                    onMessageSend: _handleMessageSend,
                    isTyping: handler.isTyping,
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
