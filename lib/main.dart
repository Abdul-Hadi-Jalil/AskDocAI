import 'package:docusense_ai/firebase_options.dart';
import 'package:docusense_ai/providers/summary_provider.dart';
import 'package:docusense_ai/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/pdf_provider.dart';
import 'providers/file_provider.dart';
import 'app_localization.dart';
import 'providers/language_provider.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SecureVault());
}

class SecureVault extends StatelessWidget {
  const SecureVault({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FileProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProxyProvider<FileProvider, PdfProvider>(
          create: (context) => PdfProvider(fileProvider: FileProvider()),
          update: (context, fileProvider, pdfProvider) =>
              PdfProvider(fileProvider: fileProvider),
        ),
        ChangeNotifierProxyProvider<FileProvider, SummaryProvider>(
          create: (context) => SummaryProvider(fileProvider: FileProvider()),
          update: (context, fileProvider, summaryProvider) =>
              SummaryProvider(fileProvider: fileProvider),
        ),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'DocuSense AI',
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: scaffoldMessengerKey,
            localizationsDelegates: const [
              AppLocalizationsDelegate(), // Use our manual delegate
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
            locale: languageProvider
                .currentLocale, // Use provider's locale instead of fixed 'en'
            theme: ThemeData(
              primaryColor: const Color(0xFF8A2BE2),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: const Color(0xFF8A2BE2),
                secondary: const Color(0xFF6A0DAD),
              ),
              useMaterial3: true,
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
