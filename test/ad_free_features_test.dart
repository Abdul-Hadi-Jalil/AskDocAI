import 'package:askdocai/app_localization.dart';
import 'package:askdocai/providers/file_provider.dart';
import 'package:askdocai/providers/pdf_provider.dart';
import 'package:askdocai/providers/summary_provider.dart';
import 'package:askdocai/screens/chat/widgets/chat_message_handler.dart';
import 'package:askdocai/screens/summary/widgets/summary_action_buttons.dart';
import 'package:askdocai/screens/summary/widgets/summary_empty.dart';
import 'package:askdocai/utils/app_theme.dart';
import 'package:askdocai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class RecordingSummaryProvider extends SummaryProvider {
  RecordingSummaryProvider(FileProvider fileProvider)
    : super(fileProvider: fileProvider);
  int calls = 0;
  @override
  Future<void> generateSummary() async {
    calls++;
  }
}

void main() {
  test('blue theme keeps readable primary and secondary button contrast', () {
    final theme = AppTheme.light;
    expect(theme.useMaterial3, isTrue);
    expect(theme.brightness, Brightness.light);
    expect(theme.colorScheme.primary, AppConstants.primaryColor);
    expect(theme.scaffoldBackgroundColor, AppConstants.backgroundColor);
    for (final color in [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
    ]) {
      expect(
        1.05 / (color.computeLuminance() + 0.05),
        greaterThanOrEqualTo(4.5),
      );
    }
    for (final language in ['en', 'es', 'fr', 'de', 'nl', 'ar', 'zh']) {
      final description = AppLocalizations(Locale(language)).signInDescription;
      expect(description, contains('Google'));
      expect(description, isNot(contains('Apple')));
    }
  });

  testWidgets('chat accepts more than three requests without a prompt gate', (
    tester,
  ) async {
    final files = FileProvider()..setFile('sample.txt', 'Sample document');
    final pdf = PdfProvider(fileProvider: files);
    final controller = InMemoryChatController();
    final handler = ChatMessageHandler(
      chatController: controller,
      uuid: const Uuid(),
      botUser: User(id: 'bot', name: 'DocuBot'),
    );
    late BuildContext chatContext;
    await tester.pumpWidget(
      ChangeNotifierProvider<PdfProvider>.value(
        value: pdf,
        child: MaterialApp(
          theme: AppTheme.light,
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
    for (var i = 0; i < 4; i++) {
      await handler.handleUserMessage(
        text: 'Question $i',
        context: chatContext,
      );
    }
    await tester.pump();
    expect(controller.messages.length, 8);
    expect(handler.isTyping, isFalse);
    expect(find.byType(AlertDialog), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    handler.dispose();
    controller.dispose();
    pdf.dispose();
    files.dispose();
  });

  testWidgets('summary generation and regeneration run directly', (
    tester,
  ) async {
    final files = FileProvider()..setFile('sample.txt', 'Sample document');
    final summary = RecordingSummaryProvider(files);
    Future<void> show(Widget child) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<SummaryProvider>.value(
          value: summary,
          child: MaterialApp(
            theme: AppTheme.light,
            localizationsDelegates: const [AppLocalizationsDelegate()],
            home: Scaffold(body: child),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await show(SummaryEmpty(fileProvider: files));
    await tester.tap(find.text('Generate Summary').last);
    await tester.pump();
    expect(summary.calls, 1);
    await show(const SummaryActionButtons());
    await tester.tap(find.text('Regenerate'));
    await tester.pump();
    expect(summary.calls, 2);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    summary.dispose();
    files.dispose();
  });
}
