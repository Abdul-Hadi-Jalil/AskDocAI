import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:uuid/uuid.dart';
import '../utils/gemini_service.dart';
import 'package:provider/provider.dart';
import 'package:docusense_ai/providers/file_state.dart';

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
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileState = context.watch<FileState>();

    return Scaffold(
      backgroundColor: const Color(0xFFf8f9fa),
      body: SafeArea(
        child: Column(
          children: [
            // --- Gradient Header ---
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1a73e8), Color(0xFF0d47a1)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 24,
                ),
                child: Column(
                  children: [
                    Text(
                      fileState.uploadedFileName ?? 'DocuChat',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Chat with your document',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // --- Chat UI Section ---
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Chat(
                    currentUserId: 'user_1',
                    chatController: _chatController,

                    resolveUser: (UserID id) async {
                      if (id == 'user_1') {
                        return User(id: id, name: 'You');
                      } else if (id == 'bot') {
                        return botUser;
                      } else {
                        return null;
                      }
                    },
                    onMessageSend: (text) async {
                      _chatController.insertMessage(
                        TextMessage(
                          id: uuid.v4(),
                          authorId: 'user_1',
                          text: text,
                          createdAt: DateTime.now(),
                        ),
                      );

                      await Future.delayed(const Duration(milliseconds: 300));

                      final response = await getGeminiResponse(
                        text,
                        fileContent: fileState.uploadedFileContent,
                        fileName: fileState.uploadedFileName,
                      );

                      _chatController.insertMessage(
                        TextMessage(
                          id: uuid.v4(),
                          authorId: botUser.id,
                          text: response,
                          createdAt: DateTime.now(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
