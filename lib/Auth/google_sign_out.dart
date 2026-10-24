import 'package:askdocai/providers/file_provider.dart';
import 'package:askdocai/providers/pdf_provider.dart';
import 'package:askdocai/providers/summary_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

Future<void> unifiedSignOut(BuildContext context) async {
  final pdfProvider = context.read<PdfProvider>();
  final fileProvider = context.read<FileProvider>();
  final summaryProvider = context.read<SummaryProvider>();
  final user = FirebaseAuth.instance.currentUser;

  await FirebaseAuth.instance.signOut();
  // Firebase authStateChanges remains the source of truth for login state.
  pdfProvider.resetUpload();
  fileProvider.clearFile();
  fileProvider.clearSelection();
  summaryProvider.clearSummary();

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.macOS) &&
      (user?.providerData.any((info) => info.providerId == 'google.com') ??
          false)) {
    try {
      await GoogleSignIn().signOut();
    } catch (error) {
      // Firebase is already signed out even if the Google session cleanup fails.
      debugPrint('Google session cleanup failed: $error');
    }
  }
}
