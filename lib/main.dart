import 'package:askdocai/utils/app_theme.dart';
import 'package:askdocai/firebase_options.dart';
import 'package:askdocai/providers/auth_state.dart';
import 'package:askdocai/providers/summary_provider.dart';
import 'package:askdocai/screens/chat/chat_screen.dart';
import 'package:askdocai/screens/quiz/quiz_screen.dart';
import 'package:askdocai/screens/splash/splash_screen.dart';
import 'package:askdocai/screens/summary/summary_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/pdf_provider.dart';
import 'providers/file_provider.dart';
import 'app_localization.dart';
import 'providers/language_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: '.env', isOptional: true);
  runApp(const SecureVault());
}

class SecureVault extends StatelessWidget {
  const SecureVault({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => FileProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProxyProvider<FileProvider, PdfProvider>(
          create: (context) =>
              PdfProvider(fileProvider: context.read<FileProvider>()),
          update: (context, fileProvider, pdfProvider) =>
              pdfProvider ?? PdfProvider(fileProvider: fileProvider),
        ),
        ChangeNotifierProxyProvider<FileProvider, SummaryProvider>(
          create: (context) =>
              SummaryProvider(fileProvider: context.read<FileProvider>()),
          update: (context, fileProvider, summaryProvider) =>
              SummaryProvider(fileProvider: fileProvider),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'AskDocAI',
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: scaffoldMessengerKey,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('es'), // Spanish
              Locale('fr'), // French
              Locale('de'), // German
              Locale('nl'), // Dutch
              Locale('ar'), // Arabic
              Locale('zh'), // Chinese
            ],
            locale: languageProvider.currentLocale,
            theme: AppTheme.light,
            home: const SplashScreen(),
            routes: {
              '/chat': (context) => ChatScreen(),
              '/summary': (context) => SummaryScreen(),
              '/quiz': (context) => QuizScreen(),
            },
          );
        },
      ),
    );
  }
}
