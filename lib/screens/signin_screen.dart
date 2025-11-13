import 'package:docusense_ai/Auth/google_auth.dart' as authService;
import 'package:docusense_ai/app_localization.dart';
import 'package:docusense_ai/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:docusense_ai/Auth/apple_auth.dart";

Future<bool> showSignInDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFFF5F5FF),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).signInToUpload,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).signInDescription,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.transparent),
                    backgroundColor: Colors.white,
                    shadowColor: Colors.black12,
                    elevation: 1,
                  ),
                  onPressed: () async {
                    try {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      Navigator.of(
                        context,
                      ).pop(true); // Return true for sign-in attempt

                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                AppLocalizations.of(
                                  context,
                                ).signingInWithGoogle,
                              ),
                            ],
                          ),
                          backgroundColor: AppConstants.primaryColor,
                          duration: const Duration(seconds: 3),
                        ),
                      );

                      final success = await authService.signInWithGoogle();
                      scaffoldMessenger.hideCurrentSnackBar();

                      if (success != null) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context).googleSignInSuccess,
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context).googleSignInFailed,
                            ),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${AppLocalizations.of(context).googleSignInError} $e',
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    FontAwesomeIcons.google,
                    color: Colors.black54,
                    size: 18,
                  ),
                  label: Text(
                    AppLocalizations.of(context).signInWithGoogle,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      Navigator.of(
                        context,
                      ).pop(true); // Return true for sign-in attempt

                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                AppLocalizations.of(context).signingInWithApple,
                              ),
                            ],
                          ),
                          backgroundColor: Colors.black,
                          duration: const Duration(seconds: 3),
                        ),
                      );

                      final success = await AppleAuth.signInWithApple();
                      scaffoldMessenger.hideCurrentSnackBar();

                      if (success != null) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context).appleSignInSuccess,
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context).appleSignInFailed,
                            ),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${AppLocalizations.of(context).appleSignInError} $e',
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    FontAwesomeIcons.apple,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    AppLocalizations.of(context).signInWithApple,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Return false for cancel
                },
                child: Text(
                  AppLocalizations.of(context).cancel,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  return result ?? false;
}
