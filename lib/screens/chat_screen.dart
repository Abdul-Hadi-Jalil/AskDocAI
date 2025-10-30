import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import '../providers/pdf_provider.dart';
import '../widgets/app_bar.dart';
import '../utils/gemini_service.dart';
import '../utils/constants.dart'; // Import your constants

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
    // Add welcome message when chat starts
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
        text:
            'Hello! I\'m ready to help you understand "$fileName". What would you like to know?',
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
      // Show error message
      _chatController.insertMessage(
        TextMessage(
          id: uuid.v4(),
          authorId: botUser.id,
          text: 'Sorry, I encountered an error. Please try again.',
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  void _showFileInfo() {
    final pdfProvider = context.read<PdfProvider>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('File Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${pdfProvider.uploadedFileName ?? 'No file'}'),
            Text(
              'Size: ${_calculateFileSize(pdfProvider.uploadedFileContent)}',
            ),
            Text('Type: PDF Document'),
            Text('Uploaded: Just now'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _calculateFileSize(String? content) {
    if (content == null) return '0 KB';
    final sizeInBytes = content.length * 2;
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1048576) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(sizeInBytes / 1048576).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final pdfProvider = context.watch<PdfProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            const CustomAppBar(),

            // File Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.lightPurple, // Use your constant
                border: Border(
                  bottom: BorderSide(
                    color: AppConstants.borderColor, // Use your constant
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // File Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppConstants.primaryColor,
                          AppConstants.secondaryColor,
                        ], // Use your constants
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ), // Use your constant
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // File Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pdfProvider.uploadedFileName ?? 'No file selected',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.textColor, // Use your constant
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _calculateFileSize(pdfProvider.uploadedFileContent),
                          style: const TextStyle(
                            fontSize: 12,
                            color:
                                AppConstants.subtitleColor, // Use your constant
                          ),
                        ),
                      ],
                    ),
                  ),

                  // File Actions
                  IconButton(
                    onPressed: _showFileInfo,
                    icon: const Icon(
                      Icons.info_outline,
                      color: AppConstants.primaryColor, // Use your constant
                    ),
                    tooltip: 'File Information',
                  ),
                ],
              ),
            ),

            // Chat UI Section
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
                      onPrimary:
                          Colors.white, // Text color on primary background
                      surface: Colors.white, // Background color
                      onSurface:
                          AppConstants.textColor, // Text color on surface
                      surfaceContainer:
                          AppConstants.lightPurple, // Container color
                      surfaceContainerLow:
                          Colors.grey.shade100, // Lower elevation container
                      surfaceContainerHigh:
                          Colors.grey.shade200, // Higher elevation container
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
