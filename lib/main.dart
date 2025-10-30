// In main.dart or wherever you setup providers
import 'package:docusense_ai/app.dart';
import 'package:docusense_ai/firebase_options.dart';
import 'package:docusense_ai/providers/summary_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pdf_provider.dart';
import 'providers/file_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SecureVault());
}

// In main.dart - update MultiProvider
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
              PdfProvider(fileProvider: fileProvider)..setContext(context),
        ),
        ChangeNotifierProxyProvider<FileProvider, SummaryProvider>(
          create: (context) => SummaryProvider(fileProvider: FileProvider()),
          update: (context, fileProvider, summaryProvider) =>
              SummaryProvider(fileProvider: fileProvider),
        ),
      ],
      child: MaterialApp(
        title: 'ChatPDF',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF8A2BE2),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF8A2BE2),
            secondary: const Color(0xFF6A0DAD),
          ),
          useMaterial3: true,
        ),
        home: const App(),
      ),
    );
  }
}
