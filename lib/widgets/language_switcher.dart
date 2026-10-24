import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:docusense_ai/providers/language_provider.dart';
import 'package:docusense_ai/app_localization.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return IconButton(
      icon: Stack(
        children: [
          const Icon(Icons.translate),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
              child: Text(
                languageProvider.getCurrentLanguageFlag(),
                style: const TextStyle(fontSize: 8, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      onPressed: () => _showLanguageDialog(context),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).selectLanguage),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildLanguageOption(context, 'English', 'en', '🇺🇸'),
                _buildLanguageOption(context, 'Español', 'es', '🇪🇸'),
                _buildLanguageOption(context, 'Français', 'fr', '🇫🇷'),
                _buildLanguageOption(context, 'Deutsch', 'de', '🇩🇪'),
                _buildLanguageOption(context, 'Nederlands', 'nl', '🇳🇱'),
                _buildLanguageOption(context, 'العربية', 'ar', '🇸🇦'),
                _buildLanguageOption(context, '中文', 'zh', '🇨🇳'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String language,
    String code,
    String flag,
  ) {
    final languageProvider = Provider.of<LanguageProvider>(
      context,
      listen: false,
    );

    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 20)),
      title: Text(language),
      trailing:
          Provider.of<LanguageProvider>(context).currentLocale.languageCode ==
              code
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () {
        languageProvider.setLocale(Locale(code));
        Navigator.of(context).pop();

        // Show confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language changed to $language'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
}
