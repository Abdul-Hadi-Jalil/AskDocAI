// import 'package:docusense_ai/utils/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_core/flutter_chat_core.dart';

// class ChatContent extends StatelessWidget {
//   final ChatController chatController;
//   final User botUser;
//   final Function(String) onMessageSend;

//   const ChatContent({
//     super.key,
//     required this.chatController,
//     required this.botUser,
//     required this.onMessageSend,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         // Chat UI Section
//         Expanded(
//           child: Container(
//             decoration: const BoxDecoration(color: Colors.white),
//             child: Chat(
//               currentUserId: 'user_1',
//               chatController: chatController,
//               theme: _buildChatTheme(),
//               resolveUser: (UserID id) async {
//                 if (id == 'user_1') {
//                   return User(id: id, name: 'You');
//                 } else if (id == 'bot') {
//                   return botUser;
//                 } else {
//                   return null;
//                 }
//               },
//               onMessageSend: onMessageSend,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   ChatTheme _buildChatTheme() {
//     return ChatTheme(
//       colors: ChatColors(
//         primary: AppConstants.primaryColor,
//         onPrimary: Colors.white,
//         surface: Colors.white,
//         onSurface: AppConstants.textColor,
//         surfaceContainer: AppConstants.lightPurple,
//         surfaceContainerLow: Colors.grey.shade100,
//         surfaceContainerHigh: Colors.grey.shade200,
//       ),
//       typography: ChatTypography(
//         bodyLarge: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.normal,
//           color: AppConstants.textColor,
//         ),
//         bodyMedium: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.normal,
//           color: AppConstants.textColor,
//         ),
//         bodySmall: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.normal,
//           color: AppConstants.subtitleColor,
//         ),
//         labelLarge: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: AppConstants.textColor,
//         ),
//         labelMedium: const TextStyle(
//           fontSize: 14,
//           fontWeight: FontWeight.w500,
//           color: AppConstants.textColor,
//         ),
//         labelSmall: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//           color: AppConstants.subtitleColor,
//         ),
//       ),
//       shape: BorderRadius.circular(AppConstants.borderRadius),
//     );
//   }
// }

import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

class ChatContent extends StatelessWidget {
  final ChatController chatController;
  final User botUser;
  final Function(String) onMessageSend;
  final bool isTyping;

  const ChatContent({
    super.key,
    required this.chatController,
    required this.botUser,
    required this.onMessageSend,
    this.isTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat UI Section
        Expanded(
          child: Stack(
            children: [
              Container(
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
              // Typing indicator overlay
              if (isTyping)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 70, // Position above the input field
                  child: _buildTypingIndicator(),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppConstants.lightPurple,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _AnimatedDot(delay: 0),
                const SizedBox(width: 4),
                _AnimatedDot(delay: 200),
                const SizedBox(width: 4),
                _AnimatedDot(delay: 400),
              ],
            ),
          ),
        ],
      ),
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

class _AnimatedDot extends StatefulWidget {
  final int delay;

  const _AnimatedDot({required this.delay});

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Start animation after delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: 0.3 + (_animation.value * 0.7),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
