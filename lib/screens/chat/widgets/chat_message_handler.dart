import 'package:askdocai/app_localization.dart';
import 'package:askdocai/providers/pdf_provider.dart';
import 'package:askdocai/utils/gemini_service.dart';
import 'package:askdocai/services/chat_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class ChatMessageHandler extends ChangeNotifier {
  final ChatController chatController;
  final Uuid uuid;
  final User botUser;
  bool _isTyping = false;
  bool _disposed = false;
  bool _isLoadingHistory = false;
  bool _isSaving = false;
  bool _loadFailed = false;
  bool _saveFailed = false;
  final List<SavedChatExchange> _unsaved = [];
  final ChatStore? store;

  bool get isLoadingHistory => _isLoadingHistory;
  bool get isSaving => _isSaving;
  bool get hasPersistenceError => _loadFailed || _saveFailed;

  bool get isTyping => _isTyping;

  ChatMessageHandler({
    required this.chatController,
    required this.uuid,
    required this.botUser,
    this.store,
  });

  Future<void> loadHistory() async {
    if (store == null || _disposed || _isLoadingHistory) return;
    _isLoadingHistory = true;
    notifyListeners();
    try {
      final exchanges = await store!.load().timeout(
        const Duration(seconds: 12),
      );
      if (_disposed) return;
      final existingIds = chatController.messages
          .map((message) => message.id)
          .toSet();
      final messages = <Message>[
        ...chatController.messages.where(
          (message) => !message.id.startsWith('welcome-'),
        ),
      ];
      for (final exchange in exchanges) {
        if (!existingIds.contains('${exchange.id}-user')) {
          messages.add(
            TextMessage(
              id: '${exchange.id}-user',
              authorId: 'user_1',
              text: exchange.question,
              createdAt: exchange.createdAt,
            ),
          );
        }
        if (!existingIds.contains('${exchange.id}-bot')) {
          messages.add(
            TextMessage(
              id: '${exchange.id}-bot',
              authorId: botUser.id,
              text: exchange.answer,
              createdAt: exchange.createdAt.add(
                const Duration(microseconds: 1),
              ),
            ),
          );
        }
      }
      messages.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      await chatController.setMessages(messages);
      _loadFailed = false;
    } catch (_) {
      _loadFailed = true;
    } finally {
      _isLoadingHistory = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> retryPersistence() async {
    if (_loadFailed) await loadHistory();
    await _savePending();
  }

  Future<void> _savePending() async {
    if (store == null || _isSaving || _disposed) return;
    _isSaving = true;
    notifyListeners();
    try {
      while (_unsaved.isNotEmpty && !_disposed) {
        await store!.save(_unsaved.first).timeout(const Duration(seconds: 12));
        _unsaved.removeAt(0);
      }
      _saveFailed = false;
    } catch (_) {
      _saveFailed = true;
      // Keep pending exchanges for an explicit retry; never report a save as successful.
    } finally {
      _isSaving = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void addWelcomeMessage(BuildContext context) {
    final pdfProvider = context.read<PdfProvider>();
    final fileName = pdfProvider.uploadedFileName ?? 'your document';

    chatController.insertMessage(
      TextMessage(
        id: 'welcome-${uuid.v4()}',
        authorId: botUser.id,
        text: AppLocalizations.of(
          context,
        ).chatWelcomeMessage.replaceAll('%fileName', fileName),
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> handleUserMessage({
    required String text,
    required BuildContext context,
  }) async {
    if (_disposed || _isTyping || _isLoadingHistory || text.trim().isEmpty) {
      return;
    }
    final pdfProvider = context.read<PdfProvider>();

    final errorMessage = AppLocalizations.of(context).errorTryAgain;

    // Add user message
    final exchangeId = uuid.v4();
    final createdAt = DateTime.now();
    _addUserMessage(text, '$exchangeId-user');

    // Show typing indicator
    _setTyping(true);

    // Get AI response
    try {
      debugPrint("🎁 Sending message to Gemini");
      final response = await getGeminiResponse(
        text,
        fileContent: pdfProvider.uploadedFileContent,
        fileName: pdfProvider.uploadedFileName,
      );

      // A screen can be closed or its account changed while Gemini is responding.
      if (_disposed) return;

      // Hide typing indicator
      _setTyping(false);

      // Add bot response
      _addBotMessage(response, id: '$exchangeId-bot');
      if (store != null) {
        _unsaved.add(
          SavedChatExchange(
            id: exchangeId,
            question: text,
            answer: response,
            createdAt: createdAt,
          ),
        );
        await _savePending();
      }
    } catch (e) {
      debugPrint("🎁 Error from Gemini: $e");
      if (!_disposed) {
        _setTyping(false);
        _addBotMessage(errorMessage);
      }
    }
  }

  void _setTyping(bool value) {
    if (_disposed) return;
    _isTyping = value;
    notifyListeners();
  }

  void _addUserMessage(String text, String id) {
    chatController.insertMessage(
      TextMessage(
        id: id,
        authorId: 'user_1',
        text: text,
        createdAt: DateTime.now(),
      ),
    );
  }

  void _addBotMessage(String text, {String? id}) {
    chatController.insertMessage(
      TextMessage(
        id: id ?? uuid.v4(),
        authorId: botUser.id,
        text: text,
        createdAt: DateTime.now(),
      ),
    );
  }
}
