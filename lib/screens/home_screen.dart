import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pdf_provider.dart';
import '../widgets/app_bar.dart';
import '../widgets/upload_section.dart';
import '../app_localization.dart'; // Add this import

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PdfProvider>(
      builder: (context, pdfProvider, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.grey[50]!],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const CustomAppBar(),
            body: const _HomeContent(),
          ),
        );
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const _WelcomeSection(),
            const SizedBox(height: 30),
            const UploadSection(),
          ],
        ),
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main heading with highlighted "Document" text
        _buildLocalizedHeading(context),
        const SizedBox(height: 10),
        // Subtitle
        Text(
          AppLocalizations.of(context).uploadAndChatDescription,
          style: const TextStyle(
            fontSize: 16, 
            color: Color(0xFF666666), 
            height: 1.5
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLocalizedHeading(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    
    // For languages that work well with the highlighted approach
    if (appLocalizations.locale.languageCode == 'en' ||
        appLocalizations.locale.languageCode == 'es' ||
        appLocalizations.locale.languageCode == 'fr' ||
        appLocalizations.locale.languageCode == 'de' ||
        appLocalizations.locale.languageCode == 'nl') {
      
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
            height: 1.3,
          ),
          children: [
            TextSpan(text: appLocalizations.chatWithAny),
            TextSpan(
              text: appLocalizations.document,
              style: TextStyle(
                backgroundColor: const Color(0xFF8A2BE2),
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      );
    } else {
      // For Arabic, Chinese and other languages where word order might be different
      // Use a simple text approach
      return Text(
        '${appLocalizations.chatWithAny} ${appLocalizations.document}',
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: Color(0xFF333333),
          height: 1.3,
        ),
        textAlign: TextAlign.center,
      );
    }
  }
}