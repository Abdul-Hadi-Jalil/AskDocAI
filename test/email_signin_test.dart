import 'dart:async';
import 'package:askdocai/app_localization.dart';
import 'package:askdocai/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> open(
    WidgetTester tester, {
    required Future<bool> Function(String, String, bool) authenticate,
    Future<void> Function(String)? reset,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [AppLocalizationsDelegate()],
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => showDialog<bool>(
                context: context,
                builder: (_) => SignInDialog(
                  googleSignIn: () async => false,
                  emailSignIn: authenticate,
                  resetPassword: reset,
                ),
              ),
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
    'email validates input, trims address and waits for authentication',
    (tester) async {
      final pending = Completer<bool>();
      final attempts = <List<Object>>[];
      await open(
        tester,
        authenticate: (email, password, create) {
          attempts.add([email, password, create]);
          return pending.future;
        },
      );
      await tester.tap(find.text('Sign in with email'));
      await tester.pumpAndSettle();
      expect(attempts, isEmpty);
      await tester.enterText(
        find.byType(TextFormField).at(0),
        '  user@example.com  ',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
      await tester.tap(find.text('Sign in with email'));
      await tester.pump();
      expect(attempts.single, ['user@example.com', 'secret123', false]);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      pending.complete(true);
      await tester.pumpAndSettle();
      expect(find.byType(SignInDialog), findsNothing);
    },
  );

  testWidgets(
    'account creation enforces minimum password and remains retryable',
    (tester) async {
      var calls = 0;
      await open(
        tester,
        authenticate: (_, password, create) async {
          expect(create, isTrue);
          expect(password, 'secret123');
          calls++;
          return false;
        },
      );
      await tester.tap(find.text('Create an account'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField).at(0),
        'user@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'short');
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();
      expect(calls, 0);
      expect(find.text('Use at least 6 characters.'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(find.byType(SignInDialog), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
    },
  );

  testWidgets('password reset validates address and does not sign user in', (
    tester,
  ) async {
    var requestedEmail = '';
    await open(
      tester,
      authenticate: (_, _, _) async => throw StateError('Unexpected sign-in'),
      reset: (email) async {
        requestedEmail = email;
      },
    );
    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    expect(requestedEmail, isEmpty);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'user@example.com',
    );
    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    expect(requestedEmail, 'user@example.com');
    expect(
      find.text('If an account exists, a password reset email has been sent.'),
      findsOneWidget,
    );
    expect(find.byType(SignInDialog), findsOneWidget);
  });
}
