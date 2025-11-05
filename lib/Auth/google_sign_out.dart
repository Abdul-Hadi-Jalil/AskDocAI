import 'package:docusense_ai/providers/auth_state.dart';
import 'package:docusense_ai/providers/file_provider.dart';
import 'package:docusense_ai/providers/pdf_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

Future<void> googleSignout(BuildContext context) async {
  try {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();

    // Reset all providers
    final authState = Provider.of<AuthState>(context, listen: false);
    final pdfProvider = Provider.of<PdfProvider>(context, listen: false);
    final fileProvider = Provider.of<FileProvider>(context, listen: false);

    authState.signOut();
    pdfProvider.resetUpload(); // Add this method if not exists
    fileProvider.clearFile();
    fileProvider.clearSelection();

    debugPrint("Successfully signed out and reset app");
  } catch (e) {
    debugPrint("Failed to sign out");
    rethrow;
  }
}
