import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

class ChatContent extends StatelessWidget {
  final ChatController chatController;
  final User botUser;
  final Function(String) onMessageSend;

  const ChatContent({
    super.key,
    required this.chatController,
    required this.botUser,
    required this.onMessageSend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat UI Section
        Expanded(
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Chat(
              currentUserId: 'user_1',
              chatController: chatController,
              theme: _buildChatTheme(),
              resolveUser: (UserID id) async {
                if (id == 'user_1') {
                  return User(id: id, name: 'You');
                } else if (id == 'bot') {
                  return botUser;
                } else {
                  return null;
                }
              },
              onMessageSend: onMessageSend,
            ),
          ),
        ),
      ],
    );
  }

  ChatTheme _buildChatTheme() {
    return ChatTheme(
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
    );
  }
}
