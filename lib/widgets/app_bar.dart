import 'package:docusense_ai/app_localization.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:docusense_ai/providers/language_provider.dart';
import 'package:docusense_ai/screens/signin_screen.dart';
import '../providers/auth_state.dart';
import '../Auth/google_sign_out.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
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
          Expanded(
            child: Text(
              AppLocalizations.of(context).appTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppConstants.textColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: ElevatedButton(
            onPressed: () async {
              if (authState.isUserSignedIn) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color(0xFFF5F5FF),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(AppLocalizations.of(context).confirmSignOut),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context).cancel,
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.primaryColor,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    unifiedSignOut(context);
                                    authState.signOut();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context).confirm,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                final signInAttempted = await showSignInDialog(context);
                if (signInAttempted && context.mounted) {
                  if (authState.isUserSignedIn) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context).signedInSuccessfully,
                        ),
                        backgroundColor: AppConstants.primaryColor,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                }
              }
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
            child: Text(
              authState.isUserSignedIn
                  ? AppLocalizations.of(context).signOut
                  : AppLocalizations.of(context).signIn,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.language),
          onPressed: () {
            _showLanguageDialog(context);
          },
        ),
      ],
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
                _buildLanguageOption(
                  context,
                  AppLocalizations.of(context).english,
                  'en',
                ),
                _buildLanguageOption(
                  context,
                  AppLocalizations.of(context).spanish,
                  'es',
                ),
                _buildLanguageOption(
                  context,
                  AppLocalizations.of(context).french,
                  'fr',
                ),
                _buildLanguageOption(
                  context,
                  AppLocalizations.of(context).german,
                  'de',
                ),
                _buildLanguageOption(
                  context,
                  AppLocalizations.of(context).dutch,
                  'nl',
                ),
                _buildLanguageOption(
                  context,
                  AppLocalizations.of(context).arabic,
                  'ar',
                ),
                _buildLanguageOption(
                  context,
                  AppLocalizations.of(context).chinese,
                  'zh',
                ),
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
