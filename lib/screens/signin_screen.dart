import 'package:docusense_ai/Auth/google_auth.dart' as authService;
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
              const Text(
                "Sign in to upload documents",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Please sign in with your Google or Apple account to continue with document uploads.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
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
                      // Show loading indicator
                      final scaffoldMessenger = ScaffoldMessenger.of(context);

                      // Close the dialog first
                      Navigator.of(context).pop(true);

                      // Show loading snackbar
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
                              SizedBox(width: 12),
                              Text('Signing in with Google...'),
                            ],
                          ),
                          backgroundColor: AppConstants.primaryColor,
                          duration: Duration(seconds: 3),
                        ),
                      );

                      // Perform Google sign-in
                      final success = await authService.signInWithGoogle();

                      // Dismiss loading snackbar
                      scaffoldMessenger.hideCurrentSnackBar();

                      if (success != null) {
                        // Show success message
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              'Signed in with Google successfully!',
                            ),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        // Show error message
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              'Google sign-in failed. Please try again.',
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    } catch (e) {
                      // Dismiss loading snackbar if any
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error during Google sign-in: $e'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    FontAwesomeIcons.google,
                    color: Colors.black54,
                    size: 18,
                  ),
                  label: const Text(
                    "Sign in with Google",
                    style: TextStyle(
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
                      // Show loading indicator
                      final scaffoldMessenger = ScaffoldMessenger.of(context);

                      // Close the dialog first
                      Navigator.of(context).pop(true);

                      // Show loading snackbar
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
                              SizedBox(width: 12),
                              Text('Signing in with Apple...'),
                            ],
                          ),
                          backgroundColor: Colors.black,
                          duration: Duration(seconds: 3),
                        ),
                      );

                      // Perform Apple sign-in
                      final success = await AppleAuth.signInWithApple();

                      // Dismiss loading snackbar
                      scaffoldMessenger.hideCurrentSnackBar();

                      if (success != null) {
                        // Show success message
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text('Signed in with Apple successfully!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {
                        // Show error message
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              'Apple sign-in failed. Please try again.',
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    } catch (e) {
                      // Dismiss loading snackbar if any
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      // Show error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error during Apple sign-in: $e'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    FontAwesomeIcons.apple,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    "Sign in with Apple",
                    style: TextStyle(
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
                  Navigator.of(context).pop(false);
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  // Return true if user attempted to sign in, false if cancelled
  return result ?? false;
}
