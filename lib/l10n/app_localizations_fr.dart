// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'DocuSense AI';

  @override
  String get tagline => 'Votre Assistant Documentaire IA';

  @override
  String get loadingApplication => 'Chargement de l\'application';

  @override
  String get pleaseUploadPdfFirst =>
      'Veuillez d\'abord télécharger un PDF pour chatter';

  @override
  String get home => 'Accueil';

  @override
  String get chat => 'Chat';

  @override
  String get quiz => 'Quiz';

  @override
  String get summary => 'Résumé';

  @override
  String get signIn => 'Se Connecter';

  @override
  String get signOut => 'Se Déconnecter';

  @override
  String get uploadFile => 'Télécharger Fichier';

  @override
  String get startQuiz => 'Commencer le Quiz';

  @override
  String get next => 'Suivant';

  @override
  String get previous => 'Précédent';

  @override
  String get submit => 'Soumettre';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Une erreur est survenue';

  @override
  String get copyright => '© 2025 DocuSense AI';
}
