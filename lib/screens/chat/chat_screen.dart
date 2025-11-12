// import 'package:docusense_ai/screens/chat/widgets/chat_content.dart';
// import 'package:docusense_ai/providers/ad_provider.dart';
// import 'package:docusense_ai/screens/chat/widgets/chat_message_handler.dart';
// import 'package:docusense_ai/widgets/file_header.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_core/flutter_chat_core.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';
// import 'package:docusense_ai/utils/ads_manager.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final _chatController = InMemoryChatController();
//   final uuid = const Uuid();
//   final User botUser = User(id: 'bot', name: 'DocuBot');
//   late ChatMessageHandler _messageHandler;

//   @override
//   void initState() {
//     super.initState();
//     _messageHandler = ChatMessageHandler(
//       chatController: _chatController,
//       uuid: uuid,
//       botUser: botUser,
//     );

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _messageHandler.addWelcomeMessage(context);
//     });

//     // Load both ads when chat screen opens
//     AdManager.loadRewardedAd();
//     AdManager.loadInterstitialAd();
//   }

//   Future<void> _handleMessageSend(String text) async {
//     await _messageHandler.handleUserMessage(text: text, context: context);
//   }

//   @override
//   void dispose() {
//     _chatController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           const FileHeader(showInfoButton: true),
//           // Prompt counter header
//           Consumer<AdProvider>(
//             builder: (context, adProvider, child) {
//               return Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   border: Border(
//                     bottom: BorderSide(color: Colors.grey.shade300),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.bolt, color: Colors.orange[700], size: 20),
//                     const SizedBox(width: 8),
//                     Text(
//                       '${adProvider.availablePrompts} ${adProvider.availablePrompts == 1 ? 'prompt' : 'prompts'} available',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14,
//                         color: Colors.blueGrey,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     if (adProvider.availablePrompts == 0)
//                       GestureDetector(
//                         onTap: () => _messageHandler.showRewardedAd(
//                           context,
//                         ), // ← Fixed this line
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.orange[700],
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.play_arrow,
//                                 color: Colors.white,
//                                 size: 16,
//                               ),
//                               const SizedBox(width: 4),
//                               const Text(
//                                 'Watch Ad for Prompt',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           Expanded(
//             child: ChatContent(
//               chatController: _chatController,
//               botUser: botUser,
//               onMessageSend: _handleMessageSend,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:docusense_ai/screens/chat/widgets/chat_content.dart';
import 'package:docusense_ai/providers/ad_provider.dart';
import 'package:docusense_ai/screens/chat/widgets/chat_message_handler.dart';
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

    // Load both ads when chat screen opens
    AdManager.loadRewardedAd();
    AdManager.loadInterstitialAd();
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
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const FileHeader(showInfoButton: true),
            // Prompt counter header
            Consumer<AdProvider>(
              builder: (context, adProvider, child) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bolt, color: Colors.orange[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '${adProvider.availablePrompts} ${adProvider.availablePrompts == 1 ? 'prompt' : 'prompts'} available',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (adProvider.availablePrompts == 0)
                        GestureDetector(
                          onTap: () => _messageHandler.showRewardedAd(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[700],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Watch Ad for Prompt',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
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
