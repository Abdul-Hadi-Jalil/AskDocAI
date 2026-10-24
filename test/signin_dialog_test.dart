import 'dart:async';
import 'package:askdocai/app_localization.dart';
import 'package:askdocai/screens/signin_screen.dart';
import 'package:askdocai/utils/gemini_service.dart' as gemini;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'AI features report missing configuration without calling the service',
    () async {
      final chat = await gemini.getGeminiResponse(
        'Summarize this',
        fileContent: 'Sample document',
        fileName: 'sample.txt',
      );
      final summary = await gemini.generateFileSummary('Sample document');
      final quiz = await gemini.generateQuiz(fileContent: 'Sample document');
      for (final result in [chat, summary, quiz]) {
        expect(result, contains('API_KEY is missing'));
      }
    },
  );

  Future<void> openDialog(
    WidgetTester tester,
    Future<bool> Function() action,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [AppLocalizationsDelegate()],
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) => SignInDialog(googleSignIn: action),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('result: $result')));
                }
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'sign-in waits for authentication and prevents duplicate attempts',
    (tester) async {
      final pending = Completer<bool>();
      var attempts = 0;
      await openDialog(tester, () {
        attempts++;
        return pending.future;
      });
      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();
      expect(find.byType(SignInDialog), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
        isNull,
      );
      expect(attempts, 1);
      pending.complete(true);
      await tester.pumpAndSettle();
      expect(find.byType(SignInDialog), findsNothing);
      expect(find.text('result: true'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('failed authentication keeps dialog open and allows retry', (
    tester,
  ) async {
    await openDialog(tester, () async => false);
    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    expect(find.byType(SignInDialog), findsOneWidget);
    expect(
      find.text('Google sign-in failed. Please try again.'),
      findsOneWidget,
    );
    expect(
      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
      isNotNull,
    );
  });

  testWidgets('provider exceptions leave Google login retryable', (
    tester,
  ) async {
    await openDialog(
      tester,
      () async => throw StateError('Provider unavailable'),
    );
    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    expect(find.byType(SignInDialog), findsOneWidget);
    expect(
      find.text('Google sign-in failed. Please try again.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
