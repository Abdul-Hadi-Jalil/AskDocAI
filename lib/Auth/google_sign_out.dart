import 'package:docusense_ai/providers/auth_state.dart';
import 'package:docusense_ai/providers/file_provider.dart';
import 'package:docusense_ai/providers/pdf_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

Future<void> unifiedSignOut(BuildContext context) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Additional provider-specific signout if needed
    if (user != null) {
      for (final userInfo in user.providerData) {
        if (userInfo.providerId == 'google.com') {
          await GoogleSignIn().signOut();
        }
        // Apple doesn't require additional signout beyond Firebase
      }
    }

    // Reset all providers
    final authState = Provider.of<AuthState>(context, listen: false);
    final pdfProvider = Provider.of<PdfProvider>(context, listen: false);
    final fileProvider = Provider.of<FileProvider>(context, listen: false);

    authState.signOut(); // Rename signOut to clearUser to avoid confusion
    pdfProvider.resetUpload();
    fileProvider.clearFile();
    fileProvider.clearSelection();

    debugPrint("Successfully signed out and reset app state");
  } catch (e) {
    debugPrint("Error during sign out: $e");
    rethrow;
  }
}
