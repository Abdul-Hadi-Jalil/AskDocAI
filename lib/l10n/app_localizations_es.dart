// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'DocuSense AI';

  @override
  String get tagline => 'Tu Asistente de Documentos con IA';

  @override
  String get loadingApplication => 'Cargando aplicación';

  @override
  String get pleaseUploadPdfFirst =>
      'Por favor, sube un PDF primero para chatear';

  @override
  String get home => 'Inicio';

  @override
  String get chat => 'Chat';

  @override
  String get quiz => 'Cuestionario';

  @override
  String get summary => 'Resumen';

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get uploadFile => 'Subir Archivo';

  @override
  String get startQuiz => 'Comenzar Quiz';

  @override
  String get next => 'Siguiente';

  @override
  String get previous => 'Anterior';

  @override
  String get submit => 'Enviar';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Ocurrió un error';

  @override
  String get copyright => '© 2025 DocuSense AI';
}
