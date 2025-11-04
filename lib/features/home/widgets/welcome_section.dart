import 'package:docusense_ai/app_localizations.dart';
import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

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
            height: 1.5,
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
