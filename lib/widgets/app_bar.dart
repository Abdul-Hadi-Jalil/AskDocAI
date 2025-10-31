import 'package:docusense_ai/app_localization.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:docusense_ai/providers/language_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20), // adjust radius as you like
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.secondaryColor,
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'D',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'DocuSense AI',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppConstants.textColor,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: ElevatedButton(
            onPressed: () {
              // Sign in functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 0,
            ),
            child: const Text(
              'Sign In',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        // settings option
        IconButton(
          icon: const Icon(Icons.language),
          onPressed: () {
            _showLanguageDialog(context);
          },
        ),
      ],
    );
  }

  // Add this method to show language selection dialog
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
                _buildLanguageOption(context, 'English', 'en'),
                _buildLanguageOption(context, 'Español', 'es'),
                _buildLanguageOption(context, 'Français', 'fr'),
                _buildLanguageOption(context, 'Deutsch', 'de'),
                _buildLanguageOption(context, 'Nederlands', 'nl'),
                _buildLanguageOption(context, 'العربية', 'ar'),
                _buildLanguageOption(context, '中文', 'zh'),
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
  ) {
    return ListTile(
      leading: Text(_getFlagEmoji(code)),
      title: Text(language),
      trailing:
          Provider.of<LanguageProvider>(context).currentLocale.languageCode ==
              code
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () {
        Provider.of<LanguageProvider>(
          context,
          listen: false,
        ).setLocale(Locale(code));
        Navigator.of(context).pop();
      },
    );
  }

  String _getFlagEmoji(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸';
      case 'es':
        return '🇪🇸';
      case 'fr':
        return '🇫🇷';
      case 'de':
        return '🇩🇪';
      case 'nl':
        return '🇳🇱';
      case 'ar':
        return '🇸🇦';
      case 'zh':
        return '🇨🇳';
      default:
        return '🌐';
    }
  }
}
