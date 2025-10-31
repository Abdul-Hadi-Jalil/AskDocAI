// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'DocuSense AI';

  @override
  String get tagline => 'Ihr KI-gestützter Dokumentenassistent';

  @override
  String get loadingApplication => 'Anwendung wird geladen';

  @override
  String get pleaseUploadPdfFirst =>
      'Bitte laden Sie zuerst eine PDF hoch, um zu chatten';

  @override
  String get home => 'Startseite';

  @override
  String get chat => 'Chat';

  @override
  String get quiz => 'Quiz';

  @override
  String get summary => 'Zusammenfassung';

  @override
  String get signIn => 'Anmelden';

  @override
  String get signOut => 'Abmelden';

  @override
  String get uploadFile => 'Datei Hochladen';

  @override
  String get startQuiz => 'Quiz Starten';

  @override
  String get next => 'Weiter';

  @override
  String get previous => 'Zurück';

  @override
  String get submit => 'Einreichen';

  @override
  String get loading => 'Lädt...';

  @override
  String get error => 'Ein Fehler ist aufgetreten';

  @override
  String get copyright => '© 2025 DocuSense AI';
}
