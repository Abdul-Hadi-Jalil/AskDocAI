// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'DocuSense AI';

  @override
  String get tagline => 'Your AI-Powered Document Assistant';

  @override
  String get loadingApplication => 'Loading application';

  @override
  String get pleaseUploadPdfFirst =>
      'Please upload a PDF first to start chatting';

  @override
  String get home => 'Home';

  @override
  String get chat => 'Chat';

  @override
  String get quiz => 'Quiz';

  @override
  String get summary => 'Summary';

  @override
  String get signIn => 'Sign In';

  @override
  String get signOut => 'Sign Out';

  @override
  String get uploadFile => 'Upload File';

  @override
  String get startQuiz => 'Start Quiz';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get submit => 'Submit';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'An error occurred';

  @override
  String get copyright => '© 2025 DocuSense AI';
}
