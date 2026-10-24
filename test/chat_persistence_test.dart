import 'dart:async';
import 'package:askdocai/app_localization.dart';
import 'package:askdocai/providers/file_provider.dart';
import 'package:askdocai/providers/pdf_provider.dart';
import 'package:askdocai/screens/chat/widgets/chat_message_handler.dart';
import 'package:askdocai/services/chat_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class MemoryStore implements ChatStore {
  final exchanges = <SavedChatExchange>[];
  bool failSave = false;
  bool failLoad = false;
  Completer<List<SavedChatExchange>>? pendingLoad;
  @override
  Future<List<SavedChatExchange>> load() async {
    if (failLoad) throw StateError('Offline');
    return pendingLoad?.future ?? exchanges;
  }

  @override
  Future<void> save(SavedChatExchange exchange) async {
    if (failSave) throw StateError('Offline');
    if (!exchanges.any((existing) => existing.id == exchange.id)) {
      exchanges.add(exchange);
    }
  }
}

ChatMessageHandler handler(
  InMemoryChatController controller,
  ChatStore store,
) => ChatMessageHandler(
  chatController: controller,
  uuid: const Uuid(),
  botUser: User(id: 'bot'),
  store: store,
);

void main() {
  test(
    'history restores question and answer in order without duplication on retry',
    () async {
      final store = MemoryStore()
        ..exchanges.add(
          SavedChatExchange(
            id: 'one',
            question: 'Question',
            answer: 'Answer',
            createdAt: DateTime(2026),
          ),
        );
      final controller = InMemoryChatController();
      final messages = handler(controller, store);
      await messages.loadHistory();
      await messages.loadHistory();
      expect(
        controller.messages.map((message) => (message as TextMessage).text),
        ['Question', 'Answer'],
      );
      expect(messages.hasPersistenceError, isFalse);
      messages.dispose();
      controller.dispose();
    },
  );

  testWidgets(
    'failed chat saves remain visible and retry without duplicating turns',
    (tester) async {
      final store = MemoryStore()..failSave = true;
      final controller = InMemoryChatController();
      final messages = handler(controller, store);
      final files = FileProvider()..setFile('sample.pdf', 'Document');
      final pdf = PdfProvider(fileProvider: files);
      late BuildContext chatContext;
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: pdf,
          child: MaterialApp(
            localizationsDelegates: const [AppLocalizationsDelegate()],
            home: Builder(
              builder: (context) {
                chatContext = context;
                return const Scaffold();
              },
            ),
          ),
        ),
      );
      await messages.handleUserMessage(text: 'Explain', context: chatContext);
      expect(controller.messages.length, 2);
      expect(messages.hasPersistenceError, isTrue);
      expect(store.exchanges, isEmpty);
      store.failSave = false;
      await messages.retryPersistence();
      await messages.retryPersistence();
      expect(store.exchanges.length, 1);
      expect(messages.hasPersistenceError, isFalse);
      expect(controller.messages.length, 2);
      await tester.pumpWidget(const SizedBox());
      messages.dispose();
      controller.dispose();
      pdf.dispose();
      files.dispose();
    },
  );

  test(
    'closing chat while history loads does not update its disposed controller',
    () async {
      final store = MemoryStore()
        ..pendingLoad = Completer<List<SavedChatExchange>>();
      final controller = InMemoryChatController();
      final messages = handler(controller, store);
      final load = messages.loadHistory();
      messages.dispose();
      controller.dispose();
      store.pendingLoad!.complete([
        SavedChatExchange(
          id: 'one',
          question: 'Question',
          answer: 'Answer',
          createdAt: DateTime(2026),
        ),
      ]);
      await load;
      expect(controller.messages, isEmpty);
    },
  );
}
