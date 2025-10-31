// In main.dart
import 'package:docusense_ai/firebase_options.dart';
import 'package:docusense_ai/providers/summary_provider.dart';
import 'package:docusense_ai/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pdf_provider.dart';
import 'providers/file_provider.dart';

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
      child: MaterialApp(
        title: 'DocuSense AI',
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldMessengerKey,
        theme: ThemeData(
          primaryColor: const Color(0xFF8A2BE2),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF8A2BE2),
            secondary: const Color(0xFF6A0DAD),
          ),
          useMaterial3: true,
        ),
        // Use home instead of named routes to avoid the null error
        home: const SplashScreen(),
      ),
    );
  }
}
